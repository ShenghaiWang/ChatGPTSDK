import Foundation

public struct TranslationsEndpoint: Endpoint {
    public struct Request: Codable {
        public enum ResponseFormat: String, Codable {
            case json
            case text
            case srt
            case verboseJSON = "verbose_json"
            case vtt
        }

        public let fileData: Data
        public let fileName: String
        public let mimeType: String
        public let model: GPTModel
        public let prompt: String?
        public let responseFormat: ResponseFormat?
        public let temperature: Float?

        enum CodingKeys: String, CodingKey {
            case fileData
            case fileName
            case mimeType
            case model
            case prompt
            case responseFormat = "response_format"
            case temperature
        }

        public init(fileData: Data,
                    fileName: String,
                    mimeType: String,
                    model: GPTModel = .whisper_1,
                    prompt: String? = nil,
                    responseFormat: ResponseFormat? = nil,
                    temperature: Float? = nil) {
            self.fileData = fileData
            self.fileName = fileName
            self.mimeType = mimeType
            self.model = model
            self.prompt = prompt
            self.responseFormat = responseFormat
            self.temperature = temperature
        }
    }

    public struct Response: Codable {
        public let text: String?
    }

    private let boundary = UUID().uuidString
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/translations")!)
        request.httpMethod = "POST"
        return request
    }()

    public let request: Request

    public init(request: Request) throws {
        self.request = request
        ["Content-Type": "multipart/form-data; boundary=\(boundary)",
         "Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let multipartForm = MultipartForm(boundary: boundary)
        multipartForm.addField(fieldName: "file",
                               fileName: request.fileName,
                               data: request.fileData,
                               mimeType: request.mimeType)
        multipartForm.addField(named: "model", value: request.model.rawValue)
        if let prompt = request.prompt {
            multipartForm.addField(named: "prompt", value: prompt)
        }

        if let responseFormat = request.responseFormat?.rawValue {
            multipartForm.addField(named: "response_format", value: responseFormat)
        }

        if let temperature = request.temperature {
            multipartForm.addField(named: "temperature", value: String(temperature))
        }

        urlRequest.httpBody = multipartForm.data
    }
}
