import Foundation

public struct DeleteFilesEndpoint: Endpoint {
    public struct Request: Codable {
        public let fileID: String

        enum CodingKeys: String, CodingKey {
            case fileID = "file_id"
        }
    }
    public struct Response: Codable {
        public let id: String
        public let object: String
        public let deleted: Bool
    }
    
    public private(set) var urlRequest: URLRequest

    private let boundary = UUID().uuidString
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/files/\(request.fileID)")!)
        urlRequest.httpMethod = "DELETE"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
