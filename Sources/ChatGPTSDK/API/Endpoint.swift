import Foundation
import Combine

public protocol Endpoint {
    associatedtype Request: Encodable
    associatedtype Response: Decodable
    var urlRequest: URLRequest { get }
    var request: Request { get }
}

extension Endpoint {
    var commonHeader: [String: String] {
        ["Content-Type": "application/json",
        "Authorization": "Bearer \(ChatGPTSDK.apiKey)"]
    }

    public func run(using apiService: APIService = URLSessionAPIService()) -> AnyPublisher<Response, Error> {
        apiService.call(endpoint: self)
    }

    public func run(using apiService: APIService = URLSessionAPIService()) async throws -> Response {
        try await apiService.call(endpoint: self)
    }

    public func run(using apiService: APIService = URLSessionAPIService(),
                    completion: @escaping (Response?, Error?) -> Void) {
        apiService.call(endpoint: self, completion: completion)
    }
}
