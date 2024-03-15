import Foundation

public struct CreateModerationEndPoint: Endpoint {
    public struct Request: Codable {
        public let model: GPTModel
        public let input: [String]

        public init(model: GPTModel = .customised("text-moderation-stable"),
                    input: [String]) {
            self.model = model
            self.input = input
        }
    }

    public struct Response: Codable {
        public struct Result: Codable {
            public struct Categories: Codable {
                public let hate: Bool
                public let hateThreatening: Bool
                public let harassment: Bool
                public let harassmentThreatening: Bool
                public let selfHarm: Bool
                public let selfHarmIntent: Bool
                public let selfHarmInstructions: Bool
                public let sexual: Bool
                public let sexualMinors: Bool
                public let violence: Bool
                public let violenceGraphic: Bool

                enum CodingKeys: String, CodingKey {
                    case hate
                    case hateThreatening = "hate/threatening"
                    case harassment
                    case harassmentThreatening = "harassment/threatening"
                    case selfHarmIntent = "self-harm/intent"
                    case selfHarmInstructions = "self-harm/instructions"
                    case selfHarm = "self-harm"
                    case sexual
                    case sexualMinors = "sexual/minors"
                    case violence
                    case violenceGraphic = "violence/graphic"
                }
            }

            public struct CategoryScores: Codable {
                public let hate: Double
                public let hateThreatening: Double
                public let harassment: Double
                public let harassmentThreatening: Double
                public let selfHarm: Double
                public let selfHarmIntent: Double
                public let selfHarmInstructions: Double
                public let sexual: Double
                public let sexualMinors: Double
                public let violence: Double
                public let violenceGraphic: Double

                enum CodingKeys: String, CodingKey {
                    case hate
                    case hateThreatening = "hate/threatening"
                    case harassment
                    case harassmentThreatening = "harassment/threatening"
                    case selfHarmIntent = "self-harm/intent"
                    case selfHarmInstructions = "self-harm/instructions"
                    case selfHarm = "self-harm"
                    case sexual
                    case sexualMinors = "sexual/minors"
                    case violence
                    case violenceGraphic = "violence/graphic"
                }
            }
            public let categories: Categories
            public let categoryScores: CategoryScores
            public let flagged: Bool

            enum CodingKeys: String, CodingKey {
                case categories
                case categoryScores = "category_scores"
                case flagged
            }
        }
        public let id: String
        public let model: String
        public let result: [Result]
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/moderations")!)
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
