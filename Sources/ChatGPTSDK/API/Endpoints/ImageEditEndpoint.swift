import Foundation

public struct ImageEditEndpoint: Endpoint {
    public typealias Response = ImagesEndpoint.Response
    public typealias Size = ImagesEndpoint.Request.Size
    public typealias ResponseFormat = ImagesEndpoint.Request.ResponseFormat

    public struct Request: Codable {
        public let image: String
        public let mask: String?
        public let prompt: String
        public let n: Int?
        public let size: Size?
        public let responseFormat: ResponseFormat?
        public let user: String?

        enum CodingKeys: String, CodingKey {
            case image
            case mask
            case prompt
            case n
            case size
            case responseFormat = "response_format"
            case user
        }

        public init(image: String,
                    mask: String? = nil,
                    prompt: String,
                    n: Int? = nil,
                    size: Size? = nil,
                    responseFormat: ResponseFormat? = nil,
                    user: String? = nil) {
            self.image = image
            self.mask = mask
            self.prompt = prompt
            self.n = n
            self.size = size
            self.responseFormat = responseFormat
            self.user = user
        }
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/images/edits")!)
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
