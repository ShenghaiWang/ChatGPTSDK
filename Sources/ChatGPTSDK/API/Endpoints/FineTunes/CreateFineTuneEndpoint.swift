import Foundation

public struct CreateFineTuneEndpoint: Endpoint {
    public struct Request: Codable {
        public struct Hyperparameters: Codable {
            public let batchSize: Int?
            public let learningRateMultiplier: Float?
            public let nEpochs: Int?

            enum CodingKeys: String, CodingKey {
                case nEpochs = "n_epochs"
                case batchSize = "batch_size"
                case learningRateMultiplier = "learning_rate_multiplier"
            }
        }
        public let model: GPTModel
        public let trainingFile: String
        public let hyperparameters: Hyperparameters?
        public let validationFile: String?
        public let suffix: String?

        enum CodingKeys: String, CodingKey {
            case model
            case trainingFile = "training_file"
            case hyperparameters
            case validationFile = "validation_file"
            case suffix
        }

        public init(model: GPTModel = .gpt_3,
                    trainingFile: String,
                    hyperparameters: Hyperparameters? = nil,
                    validationFile: String? = nil,
                    suffix: String? = nil) {
            self.model = model
            self.trainingFile = trainingFile
            self.hyperparameters = hyperparameters
            self.validationFile = validationFile
            self.suffix = suffix
        }
    }

    public struct Response: Codable {
        public struct Error: Codable {
            public let code: String
            public let message: String
            public let param: String?
        }
        public let id: String
        public let createdAt: Date
        public let error: Error?
        public let fineTunedModel: String?
        public let finishedAt: Date?
        public let hyperparameters: Request.Hyperparameters
        public let model: GPTModel
        public let object: String
        public let organizationID: String
        public let resultFiles: [String]
        public let status: String
        public let trainedTokens: Int?
        public let trainingFile: String
        public let validationFile: String?

        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case error
            case fineTunedModel = "fine_tuned_model"
            case finishedAt = "finishedAt_at"
            case hyperparameters
            case model
            case object
            case organizationID = "organization_id"
            case resultFiles = "result_files"
            case status
            case trainedTokens = "trained_tokens"
            case trainingFile = "training_file"
            case validationFile = "validation_file"
        }
    }

    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/fine_tuning/jobs")!)
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
