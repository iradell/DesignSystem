import SwiftUI

// MARK: - Prompt Answer Card

public struct PromptAnswerCard: View {
    private let label: String
    private let answer: String

    public init(label: String = "SOPHIE'S ANSWER", answer: String) {
        self.label = label
        self.answer = answer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Colors.textSecondary)
                .tracking(1.5)

            Text(answer)
                .font(Typography.bodyMedium)
                .foregroundStyle(Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("Prompt Answer Card") {
    PromptAnswerCard(
        label: "SOPHIE'S ANSWER",
        answer: "\"I think Interstellar is actually a masterpiece that most people misunderstand. The vibe is just unmatched.\""
    )
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
