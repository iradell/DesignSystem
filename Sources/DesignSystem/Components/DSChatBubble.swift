import SwiftUI

// MARK: - Chat Bubble Style

public enum DSChatBubbleStyle {
    case sent
    case received
}

// MARK: - Chat Bubble

public struct DSChatBubble: View {
    private let text: String
    private let style: DSChatBubbleStyle
    private let timestamp: String
    private let status: String?

    public init(
        _ text: String,
        style: DSChatBubbleStyle,
        timestamp: String,
        status: String? = nil
    ) {
        self.text = text
        self.style = style
        self.timestamp = timestamp
        self.status = status
    }

    public var body: some View {
        VStack(alignment: style == .sent ? .trailing : .leading, spacing: DSSpacing.xxs) {
            bubble

            timestampView
        }
        .frame(maxWidth: .infinity, alignment: style == .sent ? .trailing : .leading)
    }

    // MARK: - Bubble

    private var bubble: some View {
        Text(text)
            .font(DSTypography.bodyDefault)
            .foregroundStyle(style == .sent ? DSColors.textOnDark : DSColors.textPrimary)
            .lineSpacing(8.75)
            .padding(.horizontal, 21)
            .padding(.vertical, 16)
            .background(bubbleBackground)
            .clipShape(bubbleShape)
            .overlay(
                bubbleShape
                    .stroke(style == .received ? DSColors.glassBorderStrong : Color.clear, lineWidth: 1)
            )
            .frame(maxWidth: 293, alignment: .leading)
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        switch style {
        case .sent:
            LinearGradient(
                colors: [DSColors.accentIndigo, DSColors.accentDeepIndigo],
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
                .font(DSTypography.tiny)
                .foregroundStyle(DSColors.textMuted)
                .tracking(0.8)

            if let status {
                Text(" • \(status.uppercased())")
                    .font(DSTypography.tiny)
                    .foregroundStyle(DSColors.textMuted)
                    .tracking(0.8)
            }
        }
        .padding(.horizontal, DSSpacing.xs)
    }
}

// MARK: - Quoted Chat Bubble

public struct DSQuotedChatBubble: View {
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
        VStack(alignment: .trailing, spacing: DSSpacing.xxs) {
            VStack(spacing: 15) {
                // Quoted vibe block
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    HStack(spacing: DSSpacing.xs) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.white.opacity(0.8))

                        Text(quoteLabel.uppercased())
                            .font(DSTypography.captionSmall)
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
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.lg)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

                // Message text
                Text(messageText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DSColors.textOnDark)
                    .lineSpacing(8.75)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(4)
            .padding(.bottom, DSSpacing.lg)
            .background(
                LinearGradient(
                    colors: [DSColors.accentIndigo, DSColors.accentDeepIndigo],
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
            .shadow(color: DSColors.accentIndigo.opacity(0.3), radius: 20, y: 8)
            .frame(maxWidth: 293)

            // Timestamp
            HStack(spacing: 0) {
                Text(timestamp.uppercased())
                    .font(DSTypography.tiny)
                    .foregroundStyle(DSColors.textMuted)
                    .tracking(0.8)

                if let status {
                    Text(" • \(status.uppercased())")
                        .font(DSTypography.tiny)
                        .foregroundStyle(DSColors.textMuted)
                        .tracking(0.8)
                }
            }
            .padding(.trailing, DSSpacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Previews

#Preview("Chat Bubbles") {
    VStack(spacing: DSSpacing.lg) {
        DSChatBubble(
            "That perspective on 'Sunshine' is so real. Most people skip the third act but it's essential for the vibe.",
            style: .received,
            timestamp: "1:12 PM"
        )

        DSChatBubble(
            "Exactly! It's the descent into madness that makes it a true vibe. I knew we'd sync on this.",
            style: .sent,
            timestamp: "1:15 PM",
            status: "Read"
        )

        DSChatBubble(
            "We should definitely do a movie night soon. ✨",
            style: .received,
            timestamp: "1:16 PM"
        )
    }
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Quoted Bubble") {
    DSQuotedChatBubble(
        quoteLabel: "Sophie's Vibe",
        quoteText: "\"Interstellar is the ultimate cinematic vibe of 2014. People miss the emotional depth.\"",
        messageText: "Exactly! That's why I think our vibes sync—we both look for that emotional resonance in the vastness.",
        timestamp: "1:15 PM",
        status: "Read"
    )
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
