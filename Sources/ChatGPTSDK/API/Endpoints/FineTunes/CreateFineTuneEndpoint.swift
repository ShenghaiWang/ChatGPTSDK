import Foundation

public struct CreateFineTuneEndpoint: Endpoint {
    public struct Request: Codable {
        public let trainingFile: String
        public let validationFile: String?
        public let model: GPTModel?
        public let nEpochs: Int?
        public let batchSize: Int?
        public let learningRateMultiplier: Float?
        public let promptLossWeight: Float?
        public let computeClassificationMetrics: Bool?
        public let classificationAndClasses: Int?
        public let classificationPositiveClass: String?
        public let classificationBetas: [Float]?
        public let suffix: String?

        enum CodingKeys: String, CodingKey {
            case trainingFile = "training_file"
            case validationFile = "validation_file"
            case model
            case nEpochs = "n_epochs"
            case batchSize = "batch_size"
            case learningRateMultiplier = "learning_rate_multiplier"
            case promptLossWeight = "prompt_loss_weight"
            case computeClassificationMetrics = "compute_classification_metrics"
            case classificationAndClasses = "classification_n_classes"
            case classificationPositiveClass = "classification_positive_class"
            case classificationBetas = "classification_betas"
            case suffix
        }

        public init(trainingFile: String,
                    validationFile: String? = nil,
                    model: GPTModel? = nil,
                    nEpochs: Int? = nil,
                    batchSize: Int? = nil,
                    learningRateMultiplier: Float? = nil,
                    promptLossWeight: Float? = nil,
                    computeClassificationMetrics: Bool? = nil,
                    classificationAndClasses: Int? = nil,
                    classificationPositiveClass: String? = nil,
                    classificationBetas: [Float]? = nil,
                    suffix: String? = nil) {
            self.trainingFile = trainingFile
            self.validationFile = validationFile
            self.model = model
            self.nEpochs = nEpochs
            self.batchSize = batchSize
            self.learningRateMultiplier = learningRateMultiplier
            self.promptLossWeight = promptLossWeight
            self.computeClassificationMetrics = computeClassificationMetrics
            self.classificationAndClasses = classificationAndClasses
            self.classificationPositiveClass = classificationPositiveClass
            self.classificationBetas = classificationBetas
            self.suffix = suffix
        }
    }

    public struct Response: Codable {
        public struct Event: Codable {
            public let object: String
            public let createdAt: Date
            public let level: String
            public let message: String

            enum CodingKeys: String, CodingKey {
                case object
                case createdAt = "created_at"
                case level
                case message
            }
        }

        public struct Hyperparams: Codable {
            public let batchSize: Int
            public let learningRateMultiplier: Float
            public let nEpochs: Int
            public let promptLossWeight: Float

            enum CodingKeys: String, CodingKey {
                case batchSize = "batch_size"
                case learningRateMultiplier = "learning_rate_multiplier"
                case nEpochs = "n_epochs"
                case promptLossWeight = "prompt_loss_weight"
            }
        }
        public let id: String
        public let object: String
        public let model: GPTModel
        public let createdAt: Date
        public let events: [Event]?
        public let fineTunedModel: String?
        public let hyperparams: Hyperparams
        public let organizationID: String
        public let resultFiles: [String]
        public let status: String
        public let validationFiles: [String]
        public let trainingFiles: [File]
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id
            case object
            case model
            case createdAt = "created_at"
            case events
            case fineTunedModel = "fine_tuned_model"
            case hyperparams
            case organizationID = "organization_id"
            case resultFiles = "result_files"
            case status
            case validationFiles = "validation_files"
            case trainingFiles = "training_files"
            case updatedAt = "updated_at"
        }
    }

    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/fine-tunes")!)
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
