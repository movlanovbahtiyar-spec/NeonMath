import SwiftUI

/// The active gaming arena screen. Displays the current score, hot streak counter, progress bar,
/// geometric drawing canvas, and multiple-choice options.
public struct GamePlayView: View {
    @Bindable var viewModel: GameViewModel
    
    @State private var isPulsing = false
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            // MARK: - Top Header Bar
            HStack {
                // Score Display
                VStack(alignment: .leading, spacing: 4) {
                    Text(Localizer.string(forKey: "score", lang: viewModel.userProfile.language))
                        .font(.system(.caption, design: .rounded).bold())
                        .foregroundColor(Color.gray.opacity(0.8))
                        .tracking(1.5)
                    
                    Text("\(viewModel.score)")
                        .font(.system(.title, design: .rounded).bold())
                        .foregroundColor(.white)
                        .contentTransition(.numericText(countsDown: false))
                }
                
                Spacer()
                
                // Streak Flame Indicator
                if viewModel.streak > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "#BD00FF")) // Purple flame
                            .shadow(color: Color(hex: "#BD00FF").opacity(0.8), radius: 8)
                        
                        Text("\(viewModel.streak)")
                            .font(.system(.title3, design: .rounded).bold())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.5))
                            .overlay(Capsule().stroke(Color(hex: "#BD00FF").opacity(0.4), lineWidth: 1.5))
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                }
                
                Spacer()
                
                // Quit button
                Button(action: {
                    viewModel.returnToLobby()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            
            // MARK: - Dynamic Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text(Localizer.string(forKey: "time_remaining", lang: viewModel.userProfile.language))
                        .font(.system(.caption2, design: .rounded).bold())
                        .foregroundColor(Color.gray.opacity(0.7))
                        .tracking(1.0)
                    
                    Spacer()
                    
                    Text(String(format: "%.1fs", viewModel.timeRemaining))
                        .font(.system(.caption, design: .rounded).monospacedDigit().bold())
                        .foregroundColor(viewModel.timeRemaining < 15.0 ? Color(hex: "#BD00FF") : Color(hex: "#00F0FF"))
                }
                
                // Progress track
                GeometryReader { geo in
                    let isLowTime = viewModel.timeRemaining < 15.0
                    let barColor = isLowTime ? Color(hex: "#BD00FF") : Color(hex: "#00F0FF")
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.08))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor)
                            .frame(width: geo.size.width * CGFloat(viewModel.timeRemaining / 60.0))
                            .shadow(color: barColor.opacity(isLowTime ? 0.9 : 0.4), radius: isLowTime ? 10 : 4)
                            .animation(.linear(duration: 0.1), value: viewModel.timeRemaining)
                    }
                }
                .frame(height: 6)
                .opacity(viewModel.timeRemaining < 15.0 ? (isPulsing ? 0.45 : 1.0) : 1.0)
                .animation(
                    viewModel.timeRemaining < 15.0 ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default,
                    value: isPulsing
                )
            }
            .padding(.horizontal)
            .onAppear {
                isPulsing = true
            }
            
            // MARK: - Prompt Area
            Text(viewModel.currentQuestion.prompt)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 48)
            
            // MARK: - Geometry Drawing Canvas
            CanvasDrawView(
                question: viewModel.currentQuestion,
                glowColor: viewModel.timeRemaining < 15.0 ? Color(hex: "#BD00FF") : Color(hex: "#00F0FF")
            )
            .shake(trigger: viewModel.shakeTrigger)
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 14) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                    NeonButton(
                        color: viewModel.timeRemaining < 15.0 ? Color(hex: "#BD00FF") : Color(hex: "#00F0FF"),
                        isSelected: viewModel.selectedAnswer == option,
                        isCorrect: viewModel.answerChecked ? (option == viewModel.currentQuestion.correctAnswer ? true : (viewModel.selectedAnswer == option ? false : nil)) : nil,
                        action: {
                            viewModel.submitAnswer(option: option)
                        }
                    ) {
                        Text(option)
                            .font(.system(.title2, design: .rounded).bold())
                            .tracking(1.0)
                    }
                    .disabled(viewModel.selectedAnswer != nil)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.vertical)
        .background(Color.black.ignoresSafeArea())
    }
}

// MARK: - Shake Animation Modifiers

struct ShakeModifier: ViewModifier {
    let trigger: Bool
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: trigger) { _, _ in
                withAnimation(.linear(duration: 0.08).repeatCount(5, autoreverses: true)) {
                    offset = 12
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    offset = 0
                }
            }
    }
}

extension View {
    func shake(trigger: Bool) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}
