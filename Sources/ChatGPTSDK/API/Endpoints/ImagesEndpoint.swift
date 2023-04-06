import Foundation

public struct ImagesEndpoint: Endpoint {
    public struct Request: Codable {
        public enum Size: String, Codable {
            case x256 = "256x256"
            case x512 = "512x512"
            case x1024 = "1024x1024"
        }

        public enum ResponseFormat: String, Codable {
            case url
            case b64_json
        }

        public let prompt: String
        public let n: Int?
        public let size: Size?
        public let responseFormat: ResponseFormat?
        public let user: String?

        enum CodingKeys: String, CodingKey {
            case prompt
            case n
            case size
            case responseFormat = "response_format"
            case user
        }

        public init(prompt: String,
                    n: Int? = nil,
                    size: Size? = nil,
                    responseFormat: ResponseFormat? = nil,
                    user: String? = nil) {
            self.prompt = prompt
            self.n = n
            self.size = size
            self.responseFormat = responseFormat
            self.user = user
        }
    }

    public struct Response: Codable {
        public struct Image: Codable {
            public let b64JSON: String?
            public let url: String?

            enum CodingKeys: String, CodingKey {
                case url
                case b64JSON = "b64_json"
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
