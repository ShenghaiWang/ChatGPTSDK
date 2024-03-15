import Foundation

public struct ImagesEndpoint: Endpoint {
    public struct Request: Codable {
        public enum Size: String, Codable {
            case x256 = "256x256"
            case x512 = "512x512"
            case x1024 = "1024x1024"
            case x1792_1024 = "1792x1024"
            case x1024_1792 = "1024x1792"
        }

        public enum ResponseFormat: String, Codable {
            case url
            case b64_json
        }

        public let prompt: String
        public let model: GPTModel
        public let n: Int?
        public let quality: String?
        public let responseFormat: ResponseFormat?
        public let size: Size?
        public let style: String?
        public let user: String?

        enum CodingKeys: String, CodingKey {
            case prompt
            case model
            case n
            case quality
            case responseFormat = "response_format"
            case size
            case style
            case user
        }

        public init(prompt: String,
                    model: GPTModel = .dall,
                    n: Int? = nil,
                    quality: String? = nil,
                    responseFormat: ResponseFormat? = nil,
                    size: Size? = nil,
                    style: String? = nil,
                    user: String? = nil) {
            self.prompt = prompt
            self.model = model
            self.n = n
            self.quality = quality
            self.responseFormat = responseFormat
            self.size = size
            self.style = style
            self.user = user
        }
    }

    public struct Response: Codable {
        public struct Image: Codable {
            public let b64JSON: String?
            public let url: String?
            public let revisedPrompt: String

            enum CodingKeys: String, CodingKey {
                case url
                case b64JSON = "b64_json"
                case revisedPrompt = "revised_prompt"
            }
        }

        public let created: Date
        public let data: [Image]
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/images/generations")!)
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
