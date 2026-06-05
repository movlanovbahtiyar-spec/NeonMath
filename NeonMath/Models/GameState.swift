import Foundation

/// Represents the high-level states of the application.
public enum GameState: Equatable {
    /// The main dashboard/lobby menu.
    case lobby
    
    /// The active game loop.
    case playing
    
    /// The screen displayed when a game finishes, containing the final score.
    case gameOver(finalScore: Int, correctAnswers: Int, totalQuestions: Int)
    
    public static func == (lhs: GameState, rhs: GameState) -> Bool {
        switch (lhs, rhs) {
        case (.lobby, .lobby):
            return true
        case (.playing, .playing):
            return true
        case let (.gameOver(lhsScore, lhsCorrect, lhsTotal), .gameOver(rhsScore, rhsCorrect, rhsTotal)):
            return lhsScore == rhsScore && lhsCorrect == rhsCorrect && lhsTotal == rhsTotal
        default:
            return false
        }
    }
}
