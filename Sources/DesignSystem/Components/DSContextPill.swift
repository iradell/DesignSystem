import SwiftUI

// MARK: - Context Pill

public struct DSContextPill: View {
    private let text: String
    private let icon: String

    public init(_ text: String, icon: String = "sparkles") {
        self.text = text
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(DSColors.accentIndigo)

            Text(text.uppercased())
                .font(DSTypography.captionSmall)
                .foregroundStyle(DSColors.textPrimary)
                .tracking(0.9)
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 7)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(DSColors.glassBorderLight, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

// MARK: - Previews

#Preview("Context Pills") {
    VStack(spacing: DSSpacing.md) {
        DSContextPill("Peek Vibe Context")
        DSContextPill("Underrated Movies")
        DSContextPill("Daily Prompt", icon: "lightbulb.fill")
    }
    .padding(DSSpacing.xxl)
    .background(DSColors.onboardingGradient)
}
