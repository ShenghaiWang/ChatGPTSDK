import Foundation

public enum GPTModel: CaseIterable, Codable {
    public static var allCases: [GPTModel] = [.gpt_3, .gpt_4, .dall, .tts, .whisper, .text_embedding, .text_moderation, .customised("")]

    case gpt_4
    case gpt_3
    case dall
    case tts
    case whisper
    case text_embedding
    case text_moderation
    case customised(String)

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = .customised(value)
        for item in GPTModel.allCases {
            if item.value == value {
                self = item
                break
            }
        }
    }
}

extension GPTModel {
    var value: String {
        switch self {
        case .gpt_4: return "gpt-4"
        case .gpt_3: return "gpt-3.5-turbo"
        case .dall: return "dall-e-3"
        case .tts: return "tts-1"
        case .whisper: return "whisper-1"
        case .text_embedding: return "text-embedding-3-large"
        case .text_moderation: return "text-moderation-stable"
        case let .customised(value): return value
        }
    }
}
