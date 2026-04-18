import SwiftUI

// MARK: - Divider with Text

public struct DSTextDivider: View {
    private let text: String

    public init(_ text: String = "OR EMAIL") {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            dividerLine
            Text(text.uppercased())
                .font(DSTypography.caption)
                .foregroundStyle(DSColors.textMuted)
                .tracking(1)
            dividerLine
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(DSColors.divider)
            .frame(height: 1)
    }
}

// MARK: - Previews

#Preview("Text Divider") {
    VStack(spacing: 30) {
        DSTextDivider()
        DSTextDivider("or continue with")
    }
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
