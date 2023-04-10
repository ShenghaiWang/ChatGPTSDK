import Foundation
import Combine
import ServerSideEvent

public protocol APIService {
    func call<E: Endpoint>(endpoint: E) -> AnyPublisher<E.Response, Error>
    func call<E: Endpoint>(endpoint: E) async throws -> E.Response
    func call<E: Endpoint>(endpoint: E, completion: @escaping (E.Response?, Error?) -> Void)
}

public enum StreamAPIError: Error, CustomDebugStringConvertible{
    case wrongStreamAPICall

    public var debugDescription: String {
        switch self {
        case .wrongStreamAPICall: return "Cannot call this api with parameter `steam=true`. Please use the api that returns Publisher"
        }
    }
}

public struct URLSessionAPIService: APIService {
    private let urlSession: URLSession
    private var doneToken: Data {
        "[DONE]".data(using: .utf8)!
    }
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    public init(configuration: URLSessionConfiguration = .default,
                delegate: URLSessionDelegate? = nil,
                delegateQueue: OperationQueue? = nil) {
        urlSession = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }

    public func call<E: Endpoint>(endpoint: E) -> AnyPublisher<E.Response, Error> {
        switch endpoint.stream {
        case false:
            return urlSession.dataTaskPublisher(for: endpoint.urlRequest)
                .tryMap { value in
                    try jsonDecoder.decode(E.Response.self, from: value.data)
                }.eraseToAnyPublisher()
        case true:
            return EventSource(request: endpoint.urlRequest, doneToken: doneToken)
                .eventPublisher
                .tryCompactMap { [jsonDecoder] event in
                    switch event {
                    case let .data(data):
                        if data.firstRange(of: doneToken) == nil {
                            return try jsonDecoder.decode(E.Response.self, from: data)
                        } else {
                            return nil
                        }
                    default: return nil
                    }
                }.eraseToAnyPublisher()
        }
    }

    public func call<E: Endpoint>(endpoint: E) async throws -> E.Response {
        guard !endpoint.stream else { throw StreamAPIError.wrongStreamAPICall }
        return try await jsonDecoder.decode(E.Response.self, from: urlSession.data(for: endpoint.urlRequest).0)
    }

    public func call<E: Endpoint>(endpoint: E, completion: @escaping (E.Response?, Error?) -> Void) {
        guard !endpoint.stream else {
            completion(nil, StreamAPIError.wrongStreamAPICall)
            return
        }
        urlSession.dataTask(with: endpoint.urlRequest) { data, _, error in
            if let data, let object = try? jsonDecoder.decode(E.Response.self, from: data) {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }.resume()
    }
}
