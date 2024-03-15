import Foundation

public struct UploadFilesEndpoint: Endpoint {
    public struct Request: Codable {
        public let file: Data
        public let purpose: File.Purpose
    }
    public struct Response: Codable {
        public let file: File
    }
    
    public private(set) var urlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/files")!)
        request.httpMethod = "POST"
        return request
    }()

    private let boundary = UUID().uuidString
    public let request: Request

    public init(request: Request) throws {
        self.request = request
        ["Content-Type": "multipart/form-data; boundary=\(boundary)",
         "Authorization": "Bearer \(ChatGPTSDK.apiKey)"].forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let multipartForm = MultipartForm(boundary: boundary)
        multipartForm.addField(fieldName:  "file",
                               fileName: "file",
                               data: request.file,
                               mimeType: "application/json")
        multipartForm.addField(named: "purpose", value: request.purpose.rawValue)
        urlRequest.httpBody = multipartForm.data
    }
}
