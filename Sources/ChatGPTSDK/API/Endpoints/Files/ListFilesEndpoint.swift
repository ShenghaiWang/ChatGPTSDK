import Foundation

public struct ListFilesEndpoint: Endpoint {
    public struct Request: Codable {}
    public struct Response: Codable {
        public let data: [File]
        public let object: String
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/files")!)
        request.httpMethod = "GET"
        return request
    }()

    public let request = Request()

    public init() throws {
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
    }
}
