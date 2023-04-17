import Foundation

public struct ChatEndpoint: Endpoint {
    public struct Message: Codable {
        public let role: String
        public let content: String

        public init(role: String, content: String) {
            self.role = role
            self.content = content
        }
    }
    public struct Request: Codable {
        public let model: GPTModel
        public let messages: [Message]
        public let temperature: Float?
        public let topP: Float?
        public let n: Int?
        public let stream: Bool?
        public let stop: [String]?
        public let maxTokens: Int?
        public let presencePenalty: Float?
        public let frequencyPenalty: Float?
        public let logitBias: String?
        public let user: String?

        enum CodingKeys: String, CodingKey {
            case model
            case messages
            case temperature
            case topP = "top_p"
            case n
            case stream
            case stop
            case maxTokens = "max_tokens"
            case presencePenalty = "presence_penalty"
            case frequencyPenalty = "frequency_penalty"
            case logitBias = "logit_bias"
            case user
        }

        public init(model: GPTModel = .gpt_3_5_turbo,
                    messages: [Message],
                    temperature: Float? = nil,
                    topP: Float? = nil,
                    n: Int? = nil,
                    stream: Bool? = nil,
                    stop: [String]? = nil,
                    maxTokens: Int? = nil,
                    presencePenalty: Float? = nil,
                    frequencyPenalty: Float? = nil,
                    logitBias: String? = nil,
                    user: String? = nil) {
            self.model = model
            self.messages = messages
            self.temperature = temperature
            self.topP = topP
            self.n = n
            self.stream = stream
            self.stop = stop
            self.maxTokens = maxTokens
            self.presencePenalty = presencePenalty
            self.frequencyPenalty = frequencyPenalty
            self.logitBias = logitBias
            self.user = user
        }
    }

    public struct Response: Codable {
        public struct Choice: Codable {
            public struct DeltaMessage: Codable {
                let content: String
            }
            public let message: Message?
            public let delta: DeltaMessage?
            public let index: Int
            public let finishReason: String?

            enum CodingKeys: String, CodingKey {
                case message
                case delta
                case index
                case finishReason = "finish_reason"
            }
        }

        public let id: String
        public let object: String
        public let created: Date
        public let model: GPTModel
        public let choices: [Choice]
        public let usage: Usage?
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        return request
    }()

    public var stream: Bool {
        request.stream ?? false
    }

    public let request: Request

    public init(request: Request) throws {
        self.request = request
        commonHeader.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
    }
}

public extension ChatEndpoint.Response.Choice {
    var content: String? {
        message?.content ?? delta?.content
    }
}
