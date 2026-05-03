import SwiftUI

// MARK: - Divider with Text

public struct TextDivider: View {
    private let text: String

    public init(_ text: String = "OR EMAIL") {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: Spacing.md) {
            dividerLine
            Text(text.uppercased())
                .font(Typography.caption)
                .foregroundStyle(Colors.textMuted)
                .tracking(1)
            dividerLine
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(Colors.divider)
            .frame(height: 1)
    }
}

// MARK: - Previews

#Preview("Text Divider") {
    VStack(spacing: 30) {
        TextDivider()
        TextDivider("or continue with")
    }
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
