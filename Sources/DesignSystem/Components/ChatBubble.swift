import SwiftUI

// MARK: - Chat Bubble Style

public enum ChatBubbleStyle {
    case sent
    case received
}

// MARK: - Chat Bubble

public struct ChatBubble: View {
    private let text: String
    private let style: ChatBubbleStyle
    private let timestamp: String
    private let status: String?

    public init(
        _ text: String,
        style: ChatBubbleStyle,
        timestamp: String,
        status: String? = nil
    ) {
        self.text = text
        self.style = style
        self.timestamp = timestamp
        self.status = status
    }

    public var body: some View {
        VStack(alignment: style == .sent ? .trailing : .leading, spacing: Spacing.xxs) {
            bubble

            timestampView
        }
        .frame(maxWidth: .infinity, alignment: style == .sent ? .trailing : .leading)
    }

    // MARK: - Bubble

    private var bubble: some View {
        Text(text)
            .font(Typography.bodyDefault)
            .foregroundStyle(style == .sent ? Colors.textOnDark : Colors.textPrimary)
            .lineSpacing(8.75)
            .padding(.horizontal, 21)
            .padding(.vertical, 16)
            .background(bubbleBackground)
            .clipShape(bubbleShape)
            .overlay(
                bubbleShape
                    .stroke(style == .received ? Colors.glassBorderStrong : Color.clear, lineWidth: 1)
            )
            .frame(maxWidth: 293, alignment: .leading)
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        switch style {
        case .sent:
            LinearGradient(
                colors: [Colors.accentIndigo, Colors.accentDeepIndigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .received:
            Color.white.opacity(0.8)
        }
    }

    private var bubbleShape: UnevenRoundedRectangle {
        switch style {
        case .sent:
            UnevenRoundedRectangle(
                topLeadingRadius: 22,
                bottomLeadingRadius: 22,
                bottomTrailingRadius: 4,
                topTrailingRadius: 22
            )
        case .received:
            UnevenRoundedRectangle(
                topLeadingRadius: 22,
                bottomLeadingRadius: 4,
                bottomTrailingRadius: 22,
                topTrailingRadius: 22
            )
        }
    }

    // MARK: - Timestamp

    private var timestampView: some View {
        HStack(spacing: 0) {
            Text(timestamp.uppercased())
                .font(Typography.tiny)
                .foregroundStyle(Colors.textMuted)
                .tracking(0.8)

            if let status {
                Text(" • \(status.uppercased())")
                    .font(Typography.tiny)
                    .foregroundStyle(Colors.textMuted)
                    .tracking(0.8)
            }
        }
        .padding(.horizontal, Spacing.xs)
    }
}

// MARK: - Quoted Chat Bubble

public struct QuotedChatBubble: View {
    private let quoteLabel: String
    private let quoteText: String
    private let messageText: String
    private let timestamp: String
    private let status: String?

    public init(
        quoteLabel: String,
        quoteText: String,
        messageText: String,
        timestamp: String,
        status: String? = nil
    ) {
        self.quoteLabel = quoteLabel
        self.quoteText = quoteText
        self.messageText = messageText
        self.timestamp = timestamp
        self.status = status
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.xxs) {
            VStack(spacing: 15) {
                // Quoted vibe block
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.white.opacity(0.8))

                        Text(quoteLabel.uppercased())
                            .font(Typography.captionSmall)
                            .foregroundStyle(Color.white.opacity(0.8))
                            .tracking(0.9)
                    }

                    Text(quoteText)
                        .font(.system(size: 14, weight: .bold, design: .serif).italic())
                        .foregroundStyle(Color.white.opacity(0.9))
                }
                .padding(17)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

                // Message text
                Text(messageText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Colors.textOnDark)
                    .lineSpacing(8.75)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(4)
            .padding(.bottom, Spacing.lg)
            .background(
                LinearGradient(
                    colors: [Colors.accentIndigo, Colors.accentDeepIndigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 30,
                    bottomLeadingRadius: 30,
                    bottomTrailingRadius: 4,
                    topTrailingRadius: 30
                )
            )
            .shadow(color: Colors.accentIndigo.opacity(0.3), radius: 20, y: 8)
            .frame(maxWidth: 293)

            // Timestamp
            HStack(spacing: 0) {
                Text(timestamp.uppercased())
                    .font(Typography.tiny)
                    .foregroundStyle(Colors.textMuted)
                    .tracking(0.8)

                if let status {
                    Text(" • \(status.uppercased())")
                        .font(Typography.tiny)
                        .foregroundStyle(Colors.textMuted)
                        .tracking(0.8)
                }
            }
            .padding(.trailing, Spacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Previews

#Preview("Chat Bubbles") {
    VStack(spacing: Spacing.lg) {
        ChatBubble(
            "That perspective on 'Sunshine' is so real. Most people skip the third act but it's essential for the vibe.",
            style: .received,
            timestamp: "1:12 PM"
        )

        ChatBubble(
            "Exactly! It's the descent into madness that makes it a true vibe. I knew we'd sync on this.",
            style: .sent,
            timestamp: "1:15 PM",
            status: "Read"
        )

        ChatBubble(
            "We should definitely do a movie night soon. ✨",
            style: .received,
            timestamp: "1:16 PM"
        )
    }
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Quoted Bubble") {
    QuotedChatBubble(
        quoteLabel: "Sophie's Vibe",
        quoteText: "\"Interstellar is the ultimate cinematic vibe of 2014. People miss the emotional depth.\"",
        messageText: "Exactly! That's why I think our vibes sync—we both look for that emotional resonance in the vastness.",
        timestamp: "1:15 PM",
        status: "Read"
    )
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
