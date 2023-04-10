import Foundation

public struct EditsEndpoint: Endpoint {
    public struct Request: Codable {
        public let model: GPTModel
        public let input: String?
        public let instruction: String
        public let n: Int?
        public let temperature: Float?
        public let topP: Float?

        enum CodingKeys: String, CodingKey {
            case model
            case input
            case instruction
            case n
            case temperature
            case topP = "top_p"
        }

        public init(model: GPTModel = .text_davinci_edit_001,
                    input: String? = nil,
                    instruction: String,
                    n: Int? = nil,
                    temperature: Float? = nil,
                    topP: Float? = nil) {
            self.model = model
            self.input = input
            self.instruction = instruction
            self.n = n
            self.temperature = temperature
            self.topP = topP
        }
    }

    public struct Response: Codable {
        public struct Choice: Codable {
            public let text: String
            public let index: Int
        }

        public let object: String
        public let created: Date
        public let choices: [Choice]
        public let usage: Usage
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/edits")!)
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
