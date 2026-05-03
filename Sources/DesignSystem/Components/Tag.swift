import SwiftUI

// MARK: - Tag / Badge

public struct Tag: View {
    private let text: String
    private let style: Style

    public enum Style {
        case accent
        case badge
    }

    public init(_ text: String, style: Style = .accent) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        Text(text.uppercased())
            .font(Typography.captionSmall)
            .tracking(0.9)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs)
            .background(backgroundColor)
            .clipShape(Capsule())
    }

    private var foregroundColor: Color {
        switch style {
        case .accent: Colors.accentIndigo
        case .badge: Colors.textOnDark
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .accent: Colors.tagBg
        case .badge: Colors.badgeBg
        }
    }
}

// MARK: - Match Badge

public struct MatchBadge: View {
    private let percentage: Int

    public init(percentage: Int) {
        self.percentage = percentage
    }

    public var body: some View {
        Tag("\(percentage)% MATCH", style: .badge)
    }
}

// MARK: - Previews

#Preview("Tags & Badges") {
    VStack(spacing: 16) {
        Tag("DAILY PROMPT")
        Tag("HOW IT WORKS")
        MatchBadge(percentage: 98)
        MatchBadge(percentage: 92)
    }
    .padding(32)
    .background(Colors.onboardingGradient)
}
