import SwiftUI

// MARK: - Chat Input Bar

public struct DSChatInputBar: View {
    private let placeholder: String
    @Binding private var text: String
    private let onAttach: (() -> Void)?
    private let onSend: () -> Void

    public init(
        _ placeholder: String = "Discuss the vibe...",
        text: Binding<String>,
        onAttach: (() -> Void)? = nil,
        onSend: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onAttach = onAttach
        self.onSend = onSend
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            // Plus / attach button
            if let onAttach {
                Button(action: onAttach) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(DSColors.textMuted)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // Text field
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(DSTypography.bodyDefault)
                        .foregroundStyle(DSColors.textMuted)
                        .padding(.leading, DSSpacing.xs)
                }

                TextField("", text: $text)
                    .font(DSTypography.bodyDefault)
                    .foregroundStyle(DSColors.textPrimary)
                    .padding(.leading, DSSpacing.xs)
            }

            // Send button
            Button(action: onSend) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(DSColors.textOnDark)
                    .frame(width: 40, height: 40)
                    .background(DSColors.primaryButtonGradient)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 15, y: 10)
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(9)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(DSColors.glassBorderStrong, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 25, y: 20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 8)
    }
}

// MARK: - Previews

#Preview("Chat Input Bar") {
    VStack {
        Spacer()
        DSChatInputBar(
            text: .constant(""),
            onAttach: {},
            onSend: {}
        )
        .padding(.horizontal, DSSpacing.xl)
        .padding(.bottom, DSSpacing.xxl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DSColors.onboardingGradient)
}

#Preview("Chat Input - With Text") {
    VStack {
        Spacer()
        DSChatInputBar(
            "Share a vibe...",
            text: .constant("This is a great conversation!"),
            onAttach: {},
            onSend: {}
        )
        .padding(.horizontal, DSSpacing.xl)
        .padding(.bottom, DSSpacing.xxl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DSColors.onboardingGradient)
}
