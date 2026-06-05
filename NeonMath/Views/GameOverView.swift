import SwiftUI

/// End screen displayed when the timer expires. Renders a vertical screenshot-friendly share card
/// containing final score stats, gold achievements, and action triggers.
public struct GameOverView: View {
    @Bindable var viewModel: GameViewModel
    
    public let finalScore: Int
    public let correctAnswers: Int
    public let totalQuestions: Int
    
    @State private var pulseScale: CGFloat = 1.0
    @State private var flashOpacity: Double = 1.0
    
    private var accuracy: Int {
        totalQuestions > 0 ? Int((Double(correctAnswers) / Double(totalQuestions)) * 100) : 0
    }
    
    public init(
        viewModel: GameViewModel,
        finalScore: Int,
        correctAnswers: Int,
        totalQuestions: Int
    ) {
        self.viewModel = viewModel
        self.finalScore = finalScore
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
    }
    
    public var body: some View {
        let lang = viewModel.userProfile.language
        
        VStack(spacing: 28) {
            Spacer()
            
            // MARK: - Red Neon Title
            VStack(spacing: 4) {
                Text(Localizer.string(forKey: "game_over", lang: lang))
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(5.0)
                    .shadow(color: Color(hex: "#FF3366"), radius: 15) // Neon Red/Pink glow
                    .shadow(color: Color(hex: "#FF3366").opacity(0.8), radius: 30)
                
                let subtitleText = lang == .tr ? "NÖRAL BAĞLANTI KESİLDİ" : "NEURAL MATRIX DISCONNECTED"
                Text(subtitleText)
                    .font(.system(.caption2, design: .rounded).bold())
                    .foregroundColor(Color.gray.opacity(0.6))
                    .tracking(3.0)
            }
            
            Spacer()
            
            // MARK: - Dikey Skor Kartı (Share Card Component)
            VStack(spacing: 24) {
                // Flash Gold Crown Badge
                if finalScore >= viewModel.userProfile.highScore && finalScore > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(Color(hex: "#FFD700")) // Gold
                        Text("\(Localizer.string(forKey: "new_high_score", lang: lang)) 🏆")
                            .font(.system(.caption, design: .rounded).bold())
                            .foregroundColor(Color(hex: "#FFD700"))
                            .tracking(1.5)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color(hex: "#FFD700").opacity(0.12))
                            .overlay(Capsule().stroke(Color(hex: "#FFD700").opacity(0.5), lineWidth: 1.5))
                    )
                    .shadow(color: Color(hex: "#FFD700").opacity(0.3), radius: 8)
                    .opacity(flashOpacity)
                    .onAppear {
                        // Flashing neon gold animation
                        withAnimation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                        ) {
                            flashOpacity = 0.3
                        }
                    }
                    .transition(.scale)
                }
                
                // Final Score Center Stage
                VStack(spacing: 6) {
                    Text(Localizer.string(forKey: "final_score", lang: lang).uppercased())
                        .font(.system(.caption, design: .rounded).bold())
                        .foregroundColor(Color.gray.opacity(0.7))
                        .tracking(3.0)
                    
                    Text("\(finalScore)")
                        .font(.system(size: 72, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: "#00F0FF").opacity(0.6), radius: 10)
                }
                
                Divider()
                    .background(Color.white.opacity(0.15))
                    .padding(.horizontal, 20)
                
                // Detailed Stats
                HStack(spacing: 30) {
                    
                    VStack(spacing: 4) {
                        Text(Localizer.string(forKey: "accuracy_rate", lang: lang).uppercased())
                            .font(.system(.caption2, design: .rounded).bold())
                            .foregroundColor(Color.gray.opacity(0.8))
                            .tracking(1.5)
                        Text("\(accuracy)%")
                            .font(.system(.title3, design: .rounded).bold())
                            .foregroundColor(Color(hex: "#39FF14")) // Neon Green
                    }
                    
                    VStack(spacing: 4) {
                        Text(Localizer.string(forKey: "solves", lang: lang).uppercased())
                            .font(.system(.caption2, design: .rounded).bold())
                            .foregroundColor(Color.gray.opacity(0.8))
                            .tracking(1.5)
                        Text("\(correctAnswers) / \(totalQuestions)")
                            .font(.system(.title3, design: .rounded).bold())
                            .foregroundColor(.white)
                    }
                }
                
                // Screenshot/Share watermark
                Text("neonmath.blitz")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.25))
                    .tracking(1.0)
                    .padding(.top, 4)
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "#00F0FF"), Color(hex: "#BD00FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2.0
                    )
                    .shadow(color: Color(hex: "#00F0FF").opacity(0.2), radius: 12)
            )
            
            Spacer()
            
            // MARK: - Action Options
            VStack(spacing: 20) {
                // Play Again Button (Neon green border)
                Button(action: {
                    HapticFeedbackManager.shared.playSoftImpact()
                    viewModel.startGame()
                }) {
                    Text(Localizer.string(forKey: "play_again", lang: lang))
                        .font(.system(.body, design: .rounded).bold())
                        .foregroundColor(.white)
                        .tracking(2.0)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.75))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#39FF14"), lineWidth: 2.0) // Neon green border
                        .shadow(color: Color(hex: "#39FF14").opacity(0.5), radius: 8 + (pulseScale - 1.0) * 100)
                )
                .scaleEffect(pulseScale)
                .padding(.horizontal, 40)
                .onAppear {
                    // Pulsing animation
                    withAnimation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                    ) {
                        pulseScale = 1.03
                    }
                }
                
                // Return to Lobby (Minimalist text link)
                Button(action: {
                    HapticFeedbackManager.shared.playSoftImpact()
                    viewModel.returnToLobby()
                }) {
                    Text(Localizer.string(forKey: "return_lobby", lang: lang))
                        .font(.system(.body, design: .rounded).bold())
                        .foregroundColor(Color.gray.opacity(0.8))
                        .tracking(1.5)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 40)
            
            Spacer()
        }
        .background(
            ZStack {
                Color.black.ignoresSafeArea()
                
                Circle()
                    .fill(Color(hex: "#FF3366").opacity(0.04))
                    .frame(width: 320, height: 320)
                    .blur(radius: 90)
            }
        )
    }
}
