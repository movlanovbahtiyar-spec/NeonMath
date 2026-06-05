import SwiftUI

/// A reusable premium panel displaying stats or achievements with glassmorphism and subtle glowing accents.
public struct ScoreCard: View {
    public let title: String
    public let value: String
    public let subtitle: String?
    public let color: Color
    
    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = Color(hex: "#00F0FF")
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            Text(title.uppercased())
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(Color.gray.opacity(0.8))
                .tracking(2.0)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.system(.title2, design: .rounded).bold())
                .foregroundColor(.white)
                .shadow(color: color.opacity(0.4), radius: 5)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.25), lineWidth: 1.5)
        )
    }
}
