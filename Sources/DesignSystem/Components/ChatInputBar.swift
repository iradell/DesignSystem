import SwiftUI

// MARK: - Chat Input Bar

public struct ChatInputBar: View {
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
        HStack(spacing: Spacing.xs) {
            // Plus / attach button
            if let onAttach {
                Button(action: onAttach) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Colors.textMuted)
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
                        .font(Typography.bodyDefault)
                        .foregroundStyle(Colors.textMuted)
                        .padding(.leading, Spacing.xs)
                }

                TextField("", text: $text)
                    .font(Typography.bodyDefault)
                    .foregroundStyle(Colors.textPrimary)
                    .padding(.leading, Spacing.xs)
            }

            // Send button
            Button(action: onSend) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Colors.textOnDark)
                    .frame(width: 40, height: 40)
                    .background(Colors.primaryButtonGradient)
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
                .stroke(Colors.glassBorderStrong, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 25, y: 20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 8)
    }
}

// MARK: - Previews

#Preview("Chat Input Bar") {
    VStack {
        Spacer()
        ChatInputBar(
            text: .constant(""),
            onAttach: {},
            onSend: {}
        )
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xxl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.onboardingGradient)
}

#Preview("Chat Input - With Text") {
    VStack {
        Spacer()
        ChatInputBar(
            "Share a vibe...",
            text: .constant("This is a great conversation!"),
            onAttach: {},
            onSend: {}
        )
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xxl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.onboardingGradient)
}
