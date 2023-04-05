public struct ChatGPTSDK {
    static private(set) var apiKey = ""

    public static func setAPIKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }
}
