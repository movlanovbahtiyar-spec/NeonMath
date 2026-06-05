import Foundation

/// Defines the supported app interface languages.
public enum AppLanguage: String, Codable, CaseIterable {
    case en = "EN"
    case tr = "TR"
}

/// Models user gameplay history, statistics, and high scores.
/// Supports Codable for simple local persistence in UserDefaults.
public struct UserProfile: Codable, Equatable {
    /// Unique identifier for the user.
    public var id: UUID
    
    /// The user's chosen display name. Defaults to "Player 1".
    public var username: String
    
    /// Highest score achieved in Blitz mode.
    public var highScore: Int
    
    /// Total number of game sessions completed.
    public var totalGamesPlayed: Int
    
    /// Total number of correct answers submitted across all games.
    public var totalCorrectAnswers: Int
    
    /// Total number of questions answered across all games.
    public var totalQuestionsAttempted: Int
    
    /// Longest consecutive correct answer streak achieved.
    public var streakRecord: Int
    
    /// The user's selected application interface language.
    public var language: AppLanguage
    
    public init(
        id: UUID = UUID(),
        username: String = "Player 1",
        highScore: Int = 0,
        totalGamesPlayed: Int = 0,
        totalCorrectAnswers: Int = 0,
        totalQuestionsAttempted: Int = 0,
        streakRecord: Int = 0,
        language: AppLanguage = .en
    ) {
        self.id = id
        self.username = username
        self.highScore = highScore
        self.totalGamesPlayed = totalGamesPlayed
        self.totalCorrectAnswers = totalCorrectAnswers
        self.totalQuestionsAttempted = totalQuestionsAttempted
        self.streakRecord = streakRecord
        self.language = language
    }
    
    // MARK: - Backward Compatible Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case highScore
        case totalGamesPlayed
        case totalCorrectAnswers
        case totalQuestionsAttempted
        case streakRecord
        case language
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.highScore = try container.decode(Int.self, forKey: .highScore)
        self.totalGamesPlayed = try container.decode(Int.self, forKey: .totalGamesPlayed)
        self.totalCorrectAnswers = try container.decode(Int.self, forKey: .totalCorrectAnswers)
        self.totalQuestionsAttempted = try container.decode(Int.self, forKey: .totalQuestionsAttempted)
        self.streakRecord = try container.decode(Int.self, forKey: .streakRecord)
        // Fallback safely to English if the language key does not exist yet in local storage
        self.language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .en
    }
    
    /// Saves the profile locally to UserDefaults.
    public func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "NeonGeometryUserProfile")
        }
    }
    
    /// Loads the saved profile from UserDefaults, or returns a default profile.
    public static func load() -> UserProfile {
        if let data = UserDefaults.standard.data(forKey: "NeonGeometryUserProfile"),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return decoded
        }
        return UserProfile()
    }
}
