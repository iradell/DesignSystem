import SwiftUI

// MARK: - Empty State

public struct EmptyState: View {
    private let icon: Image
    private let headline: String
    private let description: String
    private let buttonTitle: String?
    private let buttonIcon: Image?
    private let statusText: String?
    private let action: (() -> Void)?

    public init(
        icon: Image = Image(systemName: "wifi.slash"),
        headline: String,
        description: String,
        buttonTitle: String? = nil,
        buttonIcon: Image? = nil,
        statusText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.headline = headline
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonIcon = buttonIcon
        self.statusText = statusText
        self.action = action
    }

    public var body: some View {
        VStack(spacing: Spacing.xl) {
            // Glass icon circle
            icon
                .font(.system(size: 28))
                .foregroundStyle(Colors.accentIndigo)
                .frame(width: 80, height: 80)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Colors.glassBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 12, y: 4)

            // Text
            VStack(spacing: Spacing.sm) {
                Text(headline)
                    .font(Typography.displayMedium.italic())
                    .foregroundStyle(Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            // Action button
            if let buttonTitle, let action {
                Button(action: action) {
                    HStack(spacing: Spacing.sm) {
                        Text(buttonTitle)
                            .font(Typography.bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundStyle(Colors.textPrimary)

                        if let buttonIcon {
                            buttonIcon
                                .font(.system(size: 16))
                                .foregroundStyle(Colors.accentIndigo)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)
                    .padding(.vertical, 18)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .stroke(Colors.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                }
                .buttonStyle(.plain)
            }

            // Status text
            if let statusText {
                Text(statusText)
                    .font(Typography.caption)
                    .foregroundStyle(Colors.textMuted)
                    .tracking(1.5)
            }
        }
        .padding(.horizontal, Spacing.xxl)
    }
}

// MARK: - Previews

#Preview("Empty State") {
    EmptyState(
        icon: Image(systemName: "wifi.slash"),
        headline: "Vibe interrupted.",
        description: "The signal timed out while connecting to the vibe-stream. Let's try to find it again.",
        buttonTitle: "Try Reconnecting",
        buttonIcon: Image(systemName: "arrow.clockwise"),
        statusText: "STATUS: SERVICES OFFLINE"
    ) {}
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.onboardingGradient)
}
