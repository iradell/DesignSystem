import SwiftUI

// MARK: - Answer Input

public struct AnswerInput: View {
    private let placeholder: String
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    public init(
        _ placeholder: String = "Write your answer here...",
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextEditor(text: $text)
            .font(Typography.bodyDefault)
            .foregroundStyle(Colors.textPrimary)
            .focused($isFocused)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 80)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(Typography.bodyDefault)
                        .foregroundStyle(Colors.textPlaceholder)
                        .padding(.horizontal, Spacing.md + 5)
                        .padding(.vertical, 14 + 8)
                        .allowsHitTesting(false)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: Radius.sm))
            .onTapGesture {
                isFocused = true
            }
    }
}

// MARK: - Previews

#Preview("Answer Input") {
    VStack(spacing: 20) {
        AnswerInput(text: .constant(""))
        AnswerInput(text: .constant("I think Interstellar is actually a masterpiece."))
    }
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
