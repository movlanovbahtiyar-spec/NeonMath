import SwiftUI

/// A cyber-minimalist button with customizable neon glow, glassmorphism, and haptic-friendly scale feedback.
public struct NeonButton<Content: View>: View {
    public let color: Color
    public let isSelected: Bool
    public let isCorrect: Bool?
    public let action: () -> Void
    public let content: () -> Content
    
    public init(
        color: Color = Color(hex: "#00F0FF"),
        isSelected: Bool = false,
        isCorrect: Bool? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.color = color
        self.isSelected = isSelected
        self.isCorrect = isCorrect
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            HapticFeedbackManager.shared.playTap()
            action()
        }) {
            content()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(NeonButtonStyle(color: color, isSelected: isSelected, isCorrect: isCorrect))
    }
}

public struct NeonButtonStyle: ButtonStyle {
    public let color: Color
    public let isSelected: Bool
    public let isCorrect: Bool?
    
    public func makeBody(configuration: Configuration) -> some View {
        let finalGlowColor: Color
        if let correct = isCorrect {
            // Neon Green for success, Futuristic Purple/Red for failure
            finalGlowColor = correct ? Color(hex: "#39FF14") : Color(hex: "#BD00FF")
        } else {
            finalGlowColor = isSelected ? color : color.opacity(0.4)
        }
        
        return configuration.label
            .font(.system(.body, design: .rounded).bold())
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.black.opacity(configuration.isPressed ? 0.85 : 0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(finalGlowColor, lineWidth: 2)
                    .shadow(color: finalGlowColor.opacity(isSelected || isCorrect != nil ? 0.8 : 0.3), radius: isSelected || isCorrect != nil ? 10 : 3)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
