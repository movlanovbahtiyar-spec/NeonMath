import Foundation
import SwiftUI
import Observation

/// The main View Model that orchestrates game loop, scoring, timer, and state transitions for Blitz Mode.
/// Uses iOS 17's `@Observable` for clean SwiftUI observation.
@Observable
@MainActor
public final class GameViewModel {
    
    // MARK: - Game State Properties
    public private(set) var gameState: GameState = .lobby
    public private(set) var userProfile: UserProfile = UserProfile.load()
    
    public private(set) var currentQuestion: Question = {
        let profile = UserProfile.load()
        return Question.generate(forQuestionIndex: 0, language: profile.language, track: profile.selectedTrack)
    }()
    public private(set) var score: Int = 0
    public private(set) var timeRemaining: Double = 60.0
    public private(set) var streak: Int = 0
    
    public private(set) var correctAnswersCount: Int = 0
    public private(set) var totalQuestionsCount: Int = 0
    
    // MARK: - View Feedback Feedback Properties
    public var selectedAnswer: String? = nil
    public var answerChecked: Bool = false
    public var isCorrect: Bool = false
    public var shakeTrigger: Bool = false
    
    // MARK: - Internals
    private let timerHolder = TimerHolder()
    private let tickInterval: Double = 0.1
    
    public init() {}
    
    deinit {
        timerHolder.invalidate()
    }
    
    // MARK: - Game Loop Controls
    
    /// Starts a new game session, resetting stats and initializing the game timer loop.
    public func startGame() {
        HapticFeedbackManager.shared.playTap()
        
        // Reset gameplay variables
        score = 0
        timeRemaining = 60.0
        streak = 0
        correctAnswersCount = 0
        totalQuestionsCount = 0
        selectedAnswer = nil
        answerChecked = false
        isCorrect = false
        
        // Generate initial question
        currentQuestion = Question.generate(forQuestionIndex: 0, language: userProfile.language, track: userProfile.selectedTrack)
        
        // Transition state
        gameState = .playing
        
        // Start countdown timer
        startTimer()
    }
    
    /// Cleans up active game sessions and returns to the main lobby menu.
    public func returnToLobby() {
        HapticFeedbackManager.shared.playSoftImpact()
        stopTimer()
        gameState = .lobby
    }
    
    /// Updates the player's username in the local profile.
    public func updateUsername(_ newName: String) {
        var profile = userProfile
        profile.username = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        if profile.username.isEmpty {
            profile.username = "Math Pilot"
        }
        profile.save()
        userProfile = profile
    }
    
    /// Resets all statistics for the player profile.
    public func resetStats() {
        let defaultProfile = UserProfile(username: userProfile.username, language: userProfile.language)
        defaultProfile.save()
        userProfile = defaultProfile
    }
    
    /// Updates the player's language preference.
    public func updateLanguage(_ newLang: AppLanguage) {
        var profile = userProfile
        profile.language = newLang
        profile.save()
        userProfile = profile
        
        // Regenerate current question to apply language changes instantly
        currentQuestion = Question.generate(forQuestionIndex: totalQuestionsCount, language: newLang, track: profile.selectedTrack)
    }
    
    /// Updates the player's curriculum track preference.
    public func updateCurriculumTrack(_ newTrack: CurriculumTrack) {
        var profile = userProfile
        profile.selectedTrack = newTrack
        profile.save()
        userProfile = profile
        
        // Regenerate current question to apply the track change instantly in the lobby
        if gameState == .lobby {
            currentQuestion = Question.generate(forQuestionIndex: totalQuestionsCount, language: userProfile.language, track: newTrack)
        }
    }
    
    /// Submits a selected answer option. Adjusts score, updates streak, adds/deducts time, and triggers haptics.
    public func submitAnswer(option: String) {
        guard selectedAnswer == nil else { return } // Prevent duplicate taps
        
        selectedAnswer = option
        answerChecked = true
        totalQuestionsCount += 1
        
        if option == currentQuestion.correctAnswer {
            isCorrect = true
            streak += 1
            correctAnswersCount += 1
            
            // Score calculation with streak multiplier
            // Base score: 100. Up to 400 with a streak >= 9
            let streakMultiplier = 1 + min(streak / 3, 3)
            score += 100 * streakMultiplier
            
            // Add +3 seconds, cap at max 60 seconds
            timeRemaining = min(60.0, timeRemaining + 3.0)
            
            HapticFeedbackManager.shared.playSuccess()
            
            // Load next question after short delay for visual confirmation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                self.nextQuestion()
            }
        } else {
            isCorrect = false
            streak = 0
            
            // Deduct -5 seconds
            timeRemaining = max(0.0, timeRemaining - 5.0)
            shakeTrigger.toggle()
            
            HapticFeedbackManager.shared.playFailure()
            
            // Load next question or end game if out of time
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                if self.timeRemaining <= 0 {
                    self.endGame()
                } else {
                    self.nextQuestion()
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    
    /// Starts the high-frequency tick timer for smooth progress reporting.
    private func startTimer() {
        stopTimer()
        let t = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        timerHolder.timer = t
    }
    
    /// Stops the timer.
    private func stopTimer() {
        timerHolder.invalidate()
    }
    
    /// Fired every 0.1 seconds. Updates the countdown and terminates the game at 0.
    private func tick() {
        guard gameState == .playing else { return }
        
        timeRemaining = max(0.0, timeRemaining - tickInterval)
        
        // Critical warning feedback when time is running out (e.g. under 10 seconds, play every 3 seconds)
        if timeRemaining < 10.0 && timeRemaining > 0 {
            let decimalPart = timeRemaining - floor(timeRemaining)
            // Play a soft reminder haptic every second under 10 seconds on the integer mark
            if decimalPart < 0.05 && Int(timeRemaining) % 2 == 0 {
                HapticFeedbackManager.shared.playWarning()
            }
        }
        
        if timeRemaining <= 0 {
            endGame()
        }
    }
    
    /// Transitions the state to next question, clearing view feedback flags.
    private func nextQuestion() {
        guard gameState == .playing else { return }
        selectedAnswer = nil
        answerChecked = false
        isCorrect = false
        currentQuestion = Question.generate(forQuestionIndex: totalQuestionsCount, language: userProfile.language, track: userProfile.selectedTrack)
    }
    
    /// Ends the active game session, updating and saving user profile achievements.
    private func endGame() {
        stopTimer()
        HapticFeedbackManager.shared.playHeavyImpact()
        
        // Update user profile statistics
        var profile = userProfile
        profile.totalGamesPlayed += 1
        profile.totalCorrectAnswers += correctAnswersCount
        profile.totalQuestionsAttempted += totalQuestionsCount
        
        if score > profile.highScore {
            profile.highScore = score
        }
        if streak > profile.streakRecord {
            profile.streakRecord = streak
        }
        
        // Report high score to Game Center
        GameCenterManager.shared.reportScore(score: score)
        
        // Persist profile
        profile.save()
        userProfile = profile
        
        // Transition to game over state
        gameState = .gameOver(
            finalScore: score,
            correctAnswers: correctAnswersCount,
            totalQuestions: totalQuestionsCount
        )
    }
}

/// A non-isolated wrapper around Timer to allow thread-safe invalidation in deinit.
private final class TimerHolder: @unchecked Sendable {
    var timer: Timer? = nil
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
