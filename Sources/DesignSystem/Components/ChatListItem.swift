import SwiftUI

// MARK: - Chat List Item

public struct ChatListItem: View {
    private let avatar: Image?
    private let avatarURL: URL?
    private let name: String
    private let message: String
    private let timestamp: String
    private let isOnline: Bool
    private let isUnread: Bool
    private let action: () -> Void

    public init(
        avatar: Image? = nil,
        avatarURL: URL? = nil,
        name: String,
        message: String,
        timestamp: String,
        isOnline: Bool = false,
        isUnread: Bool = false,
        action: @escaping () -> Void
    ) {
        self.avatar = avatar
        self.avatarURL = avatarURL
        self.name = name
        self.message = message
        self.timestamp = timestamp
        self.isOnline = isOnline
        self.isUnread = isUnread
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                ZStack(alignment: .topTrailing) {
                    Avatar(image: avatar, imageURL: avatarURL, size: 56)

                    if isOnline {
                        Circle()
                            .fill(Colors.onlineGreen)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(x: 2, y: -2)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(name)
                            .font(Typography.bodyMedium)
                            .fontWeight(.bold)
                            .foregroundStyle(Colors.textPrimary)

                        Spacer()

                        Text(timestamp)
                            .font(Typography.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: 0x8E8E93))
                    }

                    Text(message)
                        .font(Typography.bodySmall)
                        .foregroundStyle(Color(hex: 0x8E8E93))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                if isUnread {
                    Circle()
                        .fill(Colors.accentIndigo)
                        .frame(width: 8, height: 8)
                        .shadow(color: Colors.accentIndigo.opacity(0.5), radius: 8)
                }
            }
            .padding(.vertical, Spacing.md)
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
        ChatListItem(
            name: "Sophie",
            message: "That movie was actually incredible, I…",
            timestamp: "12:42 PM",
            isOnline: true,
            isUnread: true
        ) {}

        ChatListItem(
            name: "Marcus",
            message: "Let's grab that espresso martini soon.",
            timestamp: "Yesterday"
        ) {}

        ChatListItem(
            name: "Elena",
            message: "Your vibe today was so real. Love it.",
            timestamp: "Tuesday"
        ) {}
    }
    .padding(.horizontal, Spacing.xl)
    .background(Colors.onboardingGradient)
}
