import SwiftUI

// MARK: - Search Bar

public struct SearchBar: View {
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
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Colors.textMuted)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(Typography.bodySmall)
                        .fontWeight(.bold)
                        .foregroundStyle(Colors.textMuted)
                }

                TextField("", text: $text)
                    .font(Typography.bodySmall)
                    .fontWeight(.bold)
                    .foregroundStyle(Colors.textPrimary)
                    .focused($isFocused)
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 15)
        .background(Colors.inputFill)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Colors.glassBorder, lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("Search Bar") {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""))
        SearchBar("Search matches...", text: .constant("Sophie"))
    }
    .padding(Spacing.xl)
    .background(Colors.onboardingGradient)
}
