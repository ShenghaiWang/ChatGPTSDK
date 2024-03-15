import Foundation

public struct ChatCompletionEndpoint: Endpoint {
    public struct Request: Codable {
        public struct Message: Codable {
            public let role: String
            public let content: String

            public init(role: String, content: String) {
                self.role = role
                self.content = content
            }
        }
        public let model: GPTModel
        public let messages: [Message]
        public let frequencyPenalty: Float?
        public let logitBias: [String: Int]?
        public let logprobs: Bool?
        public let topLogprobs: Int?
        public let maxTokens: Int?
        public let n: Int?
        public let presencePenalty: Float?
        public let responseFormat: [String: String]? // TODO: make it strong type
        public let seed: Int?
        public let stop: [String]?
        public let stream: Bool?
        public let temperature: Float?
        public let topP: Float?
        public let tools: [String]?
        public let toolChoice: String?

        enum CodingKeys: String, CodingKey {
            case model
            case messages
            case frequencyPenalty = "frequency_penalty"
            case logitBias = "logit_bias"
            case logprobs
            case topLogprobs = "top_logprobs"
            case maxTokens = "max_tokens"
            case n
            case presencePenalty = "presence_penalty"
            case responseFormat = "response_format"
            case seed
            case stop
            case stream
            case temperature
            case topP = "top_p"
            case tools
            case toolChoice = "tool_choice"
        }

        public init(model: GPTModel = .gpt_3,
                    messages: [Message],
                    frequencyPenalty: Float? = nil,
                    logitBias: [String: Int]? = nil,
                    logprobs: Bool? = nil,
                    topLogprobs: Int? = nil,
                    maxTokens: Int? = nil,
                    n: Int? = nil,
                    presencePenalty: Float? = nil,
                    responseFormat: [String: String]? = nil,
                    seed: Int? = nil,
                    stop: [String]? = nil,
                    stream: Bool? = nil,
                    temperature: Float? = nil,
                    topP: Float? = nil,
                    tools: [String]? = nil,
                    toolChoice: String? = nil) {
            self.model = model
            self.messages = messages
            self.frequencyPenalty = frequencyPenalty
            self.logitBias = logitBias
            self.logprobs = logprobs
            self.topLogprobs = topLogprobs
            self.maxTokens = maxTokens
            self.n = n
            self.presencePenalty = presencePenalty
            self.responseFormat = responseFormat
            self.seed = seed
            self.stop = stop
            self.stream = stream
            self.temperature = temperature
            self.topP = topP
            self.tools = tools
            self.toolChoice = toolChoice
        }
    }

    public struct Response: Codable {
        public struct Choice: Codable {
            public let text: String
            public let index: Int
            public let logprobs: String?
            public let finishReason: String?

            enum CodingKeys: String, CodingKey {
                case text
                case index
                case logprobs
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
