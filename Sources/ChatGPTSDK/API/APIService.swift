import Foundation
import Combine

public protocol APIService {
    func call<E>(endpoint: E) -> AnyPublisher<E.Response, Error> where E: Endpoint
    func call<E>(endpoint: E) async throws -> E.Response where E: Endpoint
    func call<E: Endpoint>(endpoint: E, completion: @escaping (E.Response?, Error?) -> Void)
}

public struct URLSessionAPIService: APIService {
    private let urlSession: URLSession

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
        urlSession.dataTaskPublisher(for: endpoint.urlRequest)
            .tryMap { value in
                try jsonDecoder.decode(E.Response.self, from: value.data)
            }.eraseToAnyPublisher()
    }

    public func call<E: Endpoint>(endpoint: E) async throws -> E.Response {
        try await jsonDecoder.decode(E.Response.self, from: urlSession.data(for: endpoint.urlRequest).0)
    }

    public func call<E: Endpoint>(endpoint: E, completion: @escaping (E.Response?, Error?) -> Void) {
        urlSession.dataTask(with: endpoint.urlRequest) { data, _, error in
            if let data, let object = try? jsonDecoder.decode(E.Response.self, from: data) {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }.resume()
    }
}
