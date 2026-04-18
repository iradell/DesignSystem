import SwiftUI

// MARK: - Step Item (How It Works)

public struct DSStepItem: View {
    private let icon: String
    private let title: String
    private let description: String

    public init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(DSColors.accentIndigo)
                .frame(width: 48, height: 48)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.md)
                        .stroke(DSColors.glassBorder.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(DSColors.textPrimary)

                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(DSColors.textSecondary)
                    .lineSpacing(5)
            }
        }
    }
}

// MARK: - Step List

public struct DSStepList: View {
    private let items: [(icon: String, title: String, description: String)]

    public init(items: [(icon: String, title: String, description: String)]) {
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                DSStepItem(icon: item.icon, title: item.title, description: item.description)
            }
        }
    }
}

// MARK: - Previews

#Preview("Step Items") {
    DSStepList(items: [
        (icon: "clock.arrow.circlepath", title: "Periodic Windows", description: "Every few hours, a new question drops. You only have a limited time to join the vibe."),
        (icon: "bubble.left.and.bubble.right", title: "Authentic Answers", description: "Respond with what's on your mind. No filters, no performance, just you."),
        (icon: "person.2", title: "Match & Discover", description: "See who vibes with your perspective. Science-backed compatibility revealed instantly."),
    ])
    .padding(32)
    .background(DSColors.onboardingGradient)
}
