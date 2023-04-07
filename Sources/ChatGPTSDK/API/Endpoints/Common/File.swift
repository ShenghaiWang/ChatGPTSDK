import Foundation

public struct File: Codable {
    public enum Purpose: String, Codable {
        case fineTune = "fine-tune"
        case answers
        case search
        case classifications
    }
    public let id: String
    public let object: String
    public let bytes: Double
    public let createdAt: Date
    public let filename: String
    public let purpose: Purpose

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case bytes
        case createdAt = "created_at"
        case filename
        case purpose
    }
}
