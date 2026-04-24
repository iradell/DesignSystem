import SwiftUI

// MARK: - Chat List Item

public struct DSChatListItem: View {
    private let avatar: Image?
    private let name: String
    private let message: String
    private let timestamp: String
    private let isUnread: Bool
    private let action: () -> Void

    public init(
        avatar: Image? = nil,
        name: String,
        message: String,
        timestamp: String,
        isUnread: Bool = false,
        action: @escaping () -> Void
    ) {
        self.avatar = avatar
        self.name = name
        self.message = message
        self.timestamp = timestamp
        self.isUnread = isUnread
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.md) {
                DSAvatar(image: avatar, size: 56)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(name)
                            .font(DSTypography.bodyMedium)
                            .foregroundStyle(DSColors.textPrimary)

                        Spacer()

                        Text(timestamp)
                            .font(DSTypography.caption)
                            .foregroundStyle(Color(hex: 0x8E8E93))
                    }

                    Text(message)
                        .font(DSTypography.bodyDefault)
                        .foregroundStyle(Color(hex: 0x8E8E93))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                if isUnread {
                    Circle()
                        .fill(DSColors.accentIndigo)
                        .frame(width: 8, height: 8)
                        .shadow(color: DSColors.accentIndigo.opacity(0.5), radius: 8)
                }
            }
            .padding(.vertical, DSSpacing.md)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Chat List Items") {
    VStack(spacing: 0) {
        DSChatListItem(
            name: "Sophie",
            message: "That movie was actually incredible, I…",
            timestamp: "12:42 PM",
            isUnread: true
        ) {}

        DSChatListItem(
            name: "Marcus",
            message: "Let's grab that espresso martini soon.",
            timestamp: "Yesterday"
        ) {}

        DSChatListItem(
            name: "Elena",
            message: "Your vibe today was so real. Love it.",
            timestamp: "Tuesday"
        ) {}
    }
    .padding(.horizontal, DSSpacing.xl)
    .background(DSColors.onboardingGradient)
}
