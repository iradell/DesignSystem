import SwiftUI

// MARK: - Search Bar

public struct DSSearchBar: View {
    private let placeholder: String
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    public init(
        _ placeholder: String = "Search conversations...",
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(DSColors.textMuted)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(DSTypography.bodyDefault)
                        .foregroundStyle(DSColors.textMuted)
                }

                TextField("", text: $text)
                    .font(DSTypography.bodyDefault)
                    .foregroundStyle(DSColors.textPrimary)
                    .focused($isFocused)
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 13)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.md)
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("Search Bar") {
    VStack(spacing: 20) {
        DSSearchBar(text: .constant(""))
        DSSearchBar("Search matches...", text: .constant("Sophie"))
    }
    .padding(DSSpacing.xl)
    .background(DSColors.onboardingGradient)
}
