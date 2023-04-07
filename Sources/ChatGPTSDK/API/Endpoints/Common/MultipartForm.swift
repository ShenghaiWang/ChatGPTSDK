import Foundation

class MultipartForm {
    private let boundary: String
    private var dataBuilder = Data()

    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }

    func addField(named name: String, value: String) {
        ["--\(boundary)\r\n".data(using: .utf8),
        "Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8),
        "Content-Type: text/plain; charset=ISO-8859-1\r\n".data(using: .utf8),
        "\r\n".data(using: .utf8),
         "\(value)\r\n".data(using: .utf8)].compactMap { $0 }.forEach {
            dataBuilder.append($0)
        }
    }

    func addField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        ["--\(boundary)\r\n".data(using: .utf8),
         "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8),
         "Content-Type: \(mimeType)\r\n".data(using: .utf8),
         "\r\n".data(using: .utf8),
         data,
         "\r\n".data(using: .utf8),].compactMap { $0 }.forEach {
            dataBuilder.append($0)
        }
    }

    var data: Data {
        dataBuilder + ("--\(boundary)--".data(using: .utf8) ?? Data())
    }
}
