import SwiftUI

// MARK: - Chat Conversation Header

/// Floating glass header for an individual chat thread — back button,
/// avatar, name, presence dot + status label, and a trailing "more" trigger
/// (typically opening a `PopoverMenu`).
public struct ChatConversationHeader: View {
    private let name: String
    private let avatarImage: Image?
    private let avatarURL: URL?
    private let statusText: String
    private let statusColor: Color
    private let onBack: () -> Void
    private let onMore: () -> Void

    public init(
        name: String,
        avatarImage: Image? = nil,
        avatarURL: URL? = nil,
        statusText: String,
        statusColor: Color = Colors.onlineGreen,
        onBack: @escaping () -> Void,
        onMore: @escaping () -> Void
    ) {
        self.name = name
        self.avatarImage = avatarImage
        self.avatarURL = avatarURL
        self.statusText = statusText
        self.statusColor = statusColor
        self.onBack = onBack
        self.onMore = onMore
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            BackButton(size: 36, action: onBack)

            HStack(spacing: 10) {
                Avatar(image: avatarImage, imageURL: avatarURL, size: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .heavy))
                        .tracking(-0.35)
                        .foregroundStyle(Colors.textPrimary)

                    HStack(spacing: Spacing.xxs) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 6, height: 6)

                        Text(statusText.uppercased())
                            .font(Typography.captionSmall)
                            .tracking(0.9)
                            .foregroundStyle(Colors.textSecondary)
                    }
                }
            }

            Spacer()

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Colors.textPrimary)
                    .frame(width: 36, height: 36)
                    .liquidGlass(shape: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.sm)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Colors.divider)
                .frame(height: 1)
        }
    }
}

// MARK: - Previews

#Preview("Chat Conversation Header") {
    VStack(spacing: 0) {
        ChatConversationHeader(
            name: "Sophie",
            statusText: "Vibing now",
            onBack: {},
            onMore: {}
        )

        ChatConversationHeader(
            name: "Sophie",
            statusText: "Active",
            statusColor: Colors.textMuted,
            onBack: {},
            onMore: {}
        )

        Spacer()
    }
    .background(Colors.onboardingGradient)
}
