import SwiftUI

// MARK: - Prompt Answer Card

public struct DSPromptAnswerCard: View {
    private let label: String
    private let answer: String

    public init(label: String = "SOPHIE'S ANSWER", answer: String) {
        self.label = label
        self.answer = answer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label)
                .font(DSTypography.caption)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(1.5)

            Text(answer)
                .font(DSTypography.bodyMedium)
                .foregroundStyle(DSColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DSSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.md)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("Prompt Answer Card") {
    DSPromptAnswerCard(
        label: "SOPHIE'S ANSWER",
        answer: "\"I think Interstellar is actually a masterpiece that most people misunderstand. The vibe is just unmatched.\""
    )
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
