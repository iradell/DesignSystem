import SwiftUI

// MARK: - Chat Reply Preview

/// The message being replied to — shared shape between the compose-time
/// `ChatReplyPreviewBanner` and `ChatBubble`'s inline reply reference.
public struct ChatReplyPreview: Sendable, Equatable {
    public let author: String
    public let snippet: String

    public init(author: String, snippet: String) {
        self.author = author
        self.snippet = snippet
    }
}

// MARK: - Chat Reply Preview Banner

/// Shown above the `ChatInputBar` while composing a reply — indigo accent
/// bar, "REPLYING TO {NAME}" label, a truncated snippet of the original
/// message, and a dismiss button to cancel the reply.
public struct ChatReplyPreviewBanner: View {
    private let preview: ChatReplyPreview
    private let onDismiss: () -> Void
    private let onTap: (() -> Void)?

    public init(
        preview: ChatReplyPreview,
        onDismiss: @escaping () -> Void,
        onTap: (() -> Void)? = nil
    ) {
        self.preview = preview
        self.onDismiss = onDismiss
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            Capsule()
                .fill(Colors.accentIndigo)
                .frame(width: 3, height: 34)

            // Only the label/snippet is tappable — the dismiss button keeps
            // its own hit area rather than sitting inside a larger button.
            Group {
                if let onTap {
                    Button(action: onTap) { previewText }
                        .buttonStyle(.plain)
                } else {
                    previewText
                }
            }

            Spacer(minLength: Spacing.xs)

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Colors.textMuted)
                    .frame(width: 24, height: 24)
                    .background(Color.black.opacity(0.05))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 14)
        .padding(.vertical, Spacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                .stroke(Colors.glassBorder, lineWidth: 1)
        )
    }

    private var previewText: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("REPLYING TO \(preview.author.uppercased())")
                .font(.system(size: 10, weight: .heavy))
                .tracking(0.5)
                .foregroundStyle(Colors.accentIndigo)

            Text(preview.snippet)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Colors.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

// MARK: - Previews

#Preview("Chat Reply Preview Banner") {
    VStack {
        Spacer()
        ChatReplyPreviewBanner(
            preview: ChatReplyPreview(
                author: "Sophie",
                snippet: "We should definitely do a movie night soon. ✨"
            ),
            onDismiss: {}
        )
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xxl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.onboardingGradient)
}
