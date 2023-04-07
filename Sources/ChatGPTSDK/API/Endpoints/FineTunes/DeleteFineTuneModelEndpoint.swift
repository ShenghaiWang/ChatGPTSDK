import Foundation

public struct DeleteFineTuneModelEndpoint: Endpoint {
    public struct Request: Codable {
        public let model: String
    }

    public struct Response: Codable {
        public let id: String
        public let object: String
        public let deleted: Bool
    }

    public private(set) var urlRequest: URLRequest
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/models/\(request.model)")!)
        urlRequest.httpMethod = "DELETE"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
