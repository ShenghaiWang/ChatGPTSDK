import Foundation

public struct RetrieveFileContentEndpoint: Endpoint {
    public typealias Response = Data
    public struct Request: Codable {
        public let fileID: String

        enum CodingKeys: String, CodingKey {
            case fileID = "file_id"
        }
    }
    
    public private(set) var urlRequest: URLRequest

    private let boundary = UUID().uuidString
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/files/\(request.fileID)/content")!)
        urlRequest.httpMethod = "GET"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
