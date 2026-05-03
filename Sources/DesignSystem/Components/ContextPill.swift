import SwiftUI

// MARK: - Context Pill

public struct ContextPill: View {
    private let text: String
    private let icon: String

    public init(_ text: String, icon: String = "sparkles") {
        self.text = text
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Colors.accentIndigo)

            Text(text.uppercased())
                .font(Typography.captionSmall)
                .foregroundStyle(Colors.textPrimary)
                .tracking(0.9)
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 7)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Colors.glassBorderLight, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

// MARK: - Previews

#Preview("Context Pills") {
    VStack(spacing: Spacing.md) {
        ContextPill("Peek Vibe Context")
        ContextPill("Underrated Movies")
        ContextPill("Daily Prompt", icon: "lightbulb.fill")
    }
    .padding(Spacing.xxl)
    .background(Colors.onboardingGradient)
}
