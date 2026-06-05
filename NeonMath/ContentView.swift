import SwiftUI

/// The root entry view for Neon Geometry.
/// Observes the GameViewModel's state and uses fluid spring-based transitions between screens.
public struct ContentView: View {
    @State private var viewModel = GameViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch viewModel.gameState {
            case .lobby:
                MainLobbyView(viewModel: viewModel)
                    .transition(
                        .opacity
                        .combined(with: .scale(scale: 0.96))
                    )
            case .playing:
                GamePlayView(viewModel: viewModel)
                    .transition(
                        .opacity
                        .combined(with: .scale(scale: 1.04))
                    )
            case let .gameOver(finalScore, correctAnswers, totalQuestions):
                GameOverView(
                    viewModel: viewModel,
                    finalScore: finalScore,
                    correctAnswers: correctAnswers,
                    totalQuestions: totalQuestions
                )
                .transition(
                    .opacity
                    .combined(with: .scale(scale: 0.96))
                )
            }
        }
        .preferredColorScheme(.dark)
        // High-end spring transitions adhering strictly to styling specifications
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.gameState)
    }
}
