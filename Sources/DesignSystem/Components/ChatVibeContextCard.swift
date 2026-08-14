import SwiftUI

// MARK: - Chat Vibe Answer

/// A single answer tile shown inside `ChatVibeContextCard`'s two-column grid.
public struct ChatVibeAnswer: Identifiable {
    public let id: String
    public let label: String
    public let quote: String
    /// `true` for the other participant's answer — rendered with an indigo
    /// tinted label to distinguish it from the current user's own answer.
    public let isMatchAnswer: Bool

    public init(
        id: String = UUID().uuidString,
        label: String,
        quote: String,
        isMatchAnswer: Bool = false
    ) {
        self.id = id
        self.label = label
        self.quote = quote
        self.isMatchAnswer = isMatchAnswer
    }
}

// MARK: - Chat Vibe Context Card

/// Expanded "peek vibe" card — surfaces the daily prompt both participants
/// answered plus their two answers side by side, so a chat thread can be
/// read against the original context. Pairs with the collapsed `ContextPill`
/// trigger that expands into this card.
public struct ChatVibeContextCard: View {
    private let prompt: String
    private let answers: [ChatVibeAnswer]
    private let onClose: () -> Void
    private let onTapAnswer: ((ChatVibeAnswer) -> Void)?

    public init(
        prompt: String,
        answers: [ChatVibeAnswer],
        onClose: @escaping () -> Void,
        onTapAnswer: ((ChatVibeAnswer) -> Void)? = nil
    ) {
        self.prompt = prompt
        self.answers = answers
        self.onClose = onClose
        self.onTapAnswer = onTapAnswer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("DAILY PROMPT REFERENCE")
                    .font(Typography.tiny)
                    .tracking(0.8)
                    .foregroundStyle(Colors.textMuted)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Colors.textMuted)
                }
                .buttonStyle(.plain)
            }

            Text(prompt)
                .font(.system(size: 16, weight: .black, design: .serif))
                .italic()
                .foregroundStyle(Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top, spacing: Spacing.xs) {
                ForEach(answers) { answer in
                    answerTile(answer)
                }
            }
        }
        .padding(21)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.xl, style: .continuous)
                .stroke(Colors.glassBorderStrong, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 50, y: 25)
    }

    @ViewBuilder
    private func answerTile(_ answer: ChatVibeAnswer) -> some View {
        if let onTapAnswer {
            Button { onTapAnswer(answer) } label: {
                answerTileContent(answer)
            }
            .buttonStyle(.plain)
        } else {
            answerTileContent(answer)
        }
    }

    private func answerTileContent(_ answer: ChatVibeAnswer) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(answer.label.uppercased())
                .font(.system(size: 7, weight: .black))
                .tracking(-0.35)
                .foregroundStyle(answer.isMatchAnswer ? Colors.accentIndigo : Colors.textSecondary)

            Text(answer.quote)
                .font(.system(size: 9, weight: .bold))
                .italic()
                .foregroundStyle(Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("Chat Vibe Context Card") {
    ChatVibeContextCard(
        prompt: "'What is the most underrated movie you've ever seen?'",
        answers: [
            ChatVibeAnswer(
                label: "Sophie's Answer",
                quote: "\"Interstellar is the ultimate cinematic vibe of 2014.\"",
                isMatchAnswer: true
            ),
            ChatVibeAnswer(
                label: "My Answer",
                quote: "\"Sunshine (2007) is a visual masterpiece that needs love.\""
            ),
        ],
        onClose: {}
    )
    .padding(Spacing.xl)
    .background(Colors.onboardingGradient)
}
