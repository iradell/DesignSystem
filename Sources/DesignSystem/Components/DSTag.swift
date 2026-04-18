import SwiftUI

// MARK: - Tag / Badge

public struct DSTag: View {
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
            .font(DSTypography.captionSmall)
            .tracking(0.9)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.xxs)
            .background(backgroundColor)
            .clipShape(Capsule())
    }

    private var foregroundColor: Color {
        switch style {
        case .accent: DSColors.accentIndigo
        case .badge: DSColors.textOnDark
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .accent: DSColors.tagBg
        case .badge: DSColors.badgeBg
        }
    }
}

// MARK: - Match Badge

public struct DSMatchBadge: View {
    private let percentage: Int

    public init(percentage: Int) {
        self.percentage = percentage
    }

    public var body: some View {
        DSTag("\(percentage)% MATCH", style: .badge)
    }
}

// MARK: - Previews

#Preview("Tags & Badges") {
    VStack(spacing: 16) {
        DSTag("DAILY PROMPT")
        DSTag("HOW IT WORKS")
        DSMatchBadge(percentage: 98)
        DSMatchBadge(percentage: 92)
    }
    .padding(32)
    .background(DSColors.onboardingGradient)
}
