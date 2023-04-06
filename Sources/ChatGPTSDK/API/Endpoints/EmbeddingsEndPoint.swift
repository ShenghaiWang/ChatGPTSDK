import Foundation

public struct EmbeddingsEndPoint: Endpoint {
    public struct Request: Codable {
        public let model: GPTModel
        public let input: [String]
        public let user: String?

        public init(model: GPTModel = .text_embedding_ada_002,
                    input: [String],
                    user: String? = nil) {
            self.model = model
            self.input = input
            self.user = user
        }
    }

    public struct Response: Codable {
        public struct Embedding: Codable {
            public let object: String
            public let index: Int
            public let embedding: [Double]
        }

        public let object: String
        public let usage: Usage
        public let data: [Embedding]
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/embeddings")!)
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
