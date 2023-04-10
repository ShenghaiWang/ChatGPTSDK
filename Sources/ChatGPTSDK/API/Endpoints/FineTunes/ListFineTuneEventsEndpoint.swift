import Foundation

public struct ListFineTuneEventsEndpoint: Endpoint {
    public struct Request: Codable {
        public let fineTuneId: String
        public let stream: Bool?

        enum CodingKeys: String, CodingKey {
            case fineTuneId = "fine_tune_id"
            case stream
        }

        public init(fineTuneId: String,
                    stream: Bool? = nil) {
            self.fineTuneId = fineTuneId
            self.stream = stream
        }
    }

    public struct Response: Codable {
        public let object: String
        public let data: [CreateFineTuneEndpoint.Response.Event]
    }

    public var stream: Bool {
        request.stream ?? false
    }

    public private(set) var urlRequest: URLRequest
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        if request.stream ?? false {
            urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/fine-tunes/\(request.fineTuneId)/events?stream=true")!)
        } else {
            urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/fine-tunes/\(request.fineTuneId)/events")!)
        }
        urlRequest.httpMethod = "GET"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
