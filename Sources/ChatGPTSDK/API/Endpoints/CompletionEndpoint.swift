import Foundation

public struct CompletionEndpoint: Endpoint {
    public struct Request: Codable {
        public let model: GPTModel
        public let prompt: String
        public let suffix: String?
        public let maxTokens: Int?
        public let temperature: Float?
        public let topP: Float?
        public let n: Int?
        public let stream: Bool?
        public let logprobs: Int?
        public let echo: Bool?
        public let stop: String?
        public let presencePenalty: Float?
        public let frequencyPenalty: Float?
        public let bestOf: Int?
        public let logitBias: String?
        public let user: String?

        enum CodingKeys: String, CodingKey {
            case model
            case prompt
            case suffix
            case maxTokens = "max_tokens"
            case temperature
            case topP = "top_p"
            case n
            case stream
            case logprobs
            case echo
            case stop
            case presencePenalty = "presence_penalty"
            case frequencyPenalty = "frequency_penalty"
            case bestOf = "best_of"
            case logitBias = "logit_bias"
            case user
        }

        public init(model: GPTModel = .text_davinci_003,
                    prompt: String,
                    suffix: String? = nil,
                    maxTokens: Int? = nil,
                    temperature: Float? = nil,
                    topP: Float? = nil,
                    n: Int? = nil,
                    stream: Bool? = nil,
                    logprobs: Int? = nil,
                    echo: Bool? = nil,
                    stop: String? = nil,
                    presencePenalty: Float? = nil,
                    frequencyPenalty: Float? = nil,
                    bestOf: Int? = nil,
                    logitBias: String? = nil,
                    user: String? = nil) {
            self.model = model
            self.prompt = prompt
            self.suffix = suffix
            self.maxTokens = maxTokens
            self.temperature = temperature
            self.topP = topP
            self.n = n
            self.stream = stream
            self.logprobs = logprobs
            self.echo = echo
            self.stop = stop
            self.presencePenalty = presencePenalty
            self.frequencyPenalty = frequencyPenalty
            self.bestOf = bestOf
            self.logitBias = logitBias
            self.user = user
        }
    }

    public struct Response: Codable {
        public struct Choice: Codable {
            public let text: String
            public let index: Int
            public let logprobs: String?
            public let finishReason: String

            enum CodingKeys: String, CodingKey {
                case text
                case index
                case logprobs
                case finishReason = "finish_reason"
            }
        }

        public struct Usage: Codable {
            public let promptTokens: Int
            public let completionTokens: Int
            public let totalTokens: Int

            enum CodingKeys: String, CodingKey {
                case promptTokens = "prompt_tokens"
                case completionTokens = "completion_tokens"
                case totalTokens = "total_tokens"
            }
        }

        public let id: String
        public let object: String
        public let created: Date
        public let model: GPTModel
        public let choices: [Choice]
        public let usage: Usage
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/completions")!)
        request.httpMethod = "POST"
        return request
    }()

    public let request: Request

    public init(request: Request) throws {
        self.request = request
        commonHeader.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
    }
}
