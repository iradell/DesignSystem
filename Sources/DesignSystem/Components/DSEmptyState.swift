import SwiftUI

// MARK: - Empty State

public struct DSEmptyState: View {
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
        VStack(spacing: DSSpacing.xl) {
            // Glass icon circle
            icon
                .font(.system(size: 28))
                .foregroundStyle(DSColors.accentIndigo)
                .frame(width: 80, height: 80)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(DSColors.glassBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 12, y: 4)

            // Text
            VStack(spacing: DSSpacing.sm) {
                Text(headline)
                    .font(DSTypography.displayMedium.italic())
                    .foregroundStyle(DSColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(DSTypography.bodyMedium)
                    .foregroundStyle(DSColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            // Action button
            if let buttonTitle, let action {
                Button(action: action) {
                    HStack(spacing: DSSpacing.sm) {
                        Text(buttonTitle)
                            .font(DSTypography.bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundStyle(DSColors.textPrimary)

                        if let buttonIcon {
                            buttonIcon
                                .font(.system(size: 16))
                                .foregroundStyle(DSColors.accentIndigo)
                        }
                    }
                    .padding(.horizontal, DSSpacing.xxl)
                    .padding(.vertical, 18)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.md)
                            .stroke(DSColors.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                }
                .buttonStyle(.plain)
            }

            // Status text
            if let statusText {
                Text(statusText)
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textMuted)
                    .tracking(1.5)
            }
        }
        .padding(.horizontal, DSSpacing.xxl)
    }
}

// MARK: - Previews

#Preview("Empty State") {
    DSEmptyState(
        icon: Image(systemName: "wifi.slash"),
        headline: "Vibe interrupted.",
        description: "The signal timed out while connecting to the vibe-stream. Let's try to find it again.",
        buttonTitle: "Try Reconnecting",
        buttonIcon: Image(systemName: "arrow.clockwise"),
        statusText: "STATUS: SERVICES OFFLINE"
    ) {}
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DSColors.onboardingGradient)
}
