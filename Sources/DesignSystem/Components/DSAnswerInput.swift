import SwiftUI

// MARK: - Answer Input

public struct DSAnswerInput: View {
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
            .font(DSTypography.bodyDefault)
            .foregroundStyle(DSColors.textPrimary)
            .focused($isFocused)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 80)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(DSTypography.bodyDefault)
                        .foregroundStyle(DSColors.textPlaceholder)
                        .padding(.horizontal, DSSpacing.md + 5)
                        .padding(.vertical, 14 + 8)
                        .allowsHitTesting(false)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: DSRadius.sm))
            .onTapGesture {
                isFocused = true
            }
    }
}

// MARK: - Previews

#Preview("Answer Input") {
    VStack(spacing: 20) {
        DSAnswerInput(text: .constant(""))
        DSAnswerInput(text: .constant("I think Interstellar is actually a masterpiece."))
    }
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
