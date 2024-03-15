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
        public struct Event: Codable {
            public let id: String
            public let createdAt: Date
            public let level: String
            public let message: String
            public let object: String

            enum CodingKeys: String, CodingKey {
                case id
                case createdAt = "created_at"
                case level
                case message
                case object
            }
        }
        public let object: String
        public let data: [Event]
    }

    public var stream: Bool {
        request.stream ?? false
    }

    public private(set) var urlRequest: URLRequest
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        urlRequest = URLRequest(url: URL(string: "https://api.openai.com/v1/fine_tuning/jobs/\(request.fineTuneId)/events")!)
        urlRequest.httpMethod = "GET"
        ["Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
