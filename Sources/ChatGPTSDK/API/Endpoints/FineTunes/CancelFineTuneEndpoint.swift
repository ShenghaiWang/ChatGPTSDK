import Foundation

public struct CancelFineTuneEndpoint: Endpoint {
    public typealias Response = CreateFineTuneEndpoint.Response
    public struct Request: Codable {
        public let fineTuneId: String

        enum CodingKeys: String, CodingKey {
            case fineTuneId = "fine_tune_id"
        }
    }

    public private(set) var urlRequest: URLRequest
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/fine-tunes/\(request.fineTuneId)/cancel")!)
        urlRequest.httpMethod = "POST"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
    }
}
