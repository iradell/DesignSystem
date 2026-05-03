import SwiftUI

// MARK: - Text Link

public struct TextLink: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(Typography.labelMedium)
                .foregroundStyle(Colors.accentIndigo)
                .tracking(1.2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Resend Timer

public struct ResendTimer: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text.uppercased())
            .font(Typography.labelMedium)
            .foregroundStyle(Colors.accentIndigo)
            .tracking(1.2)
    }
}

// MARK: - Previews

#Preview("Text Link & Resend Timer") {
    VStack(spacing: 20) {
        TextLink("Forgot Password?") {}
        TextLink("Terms & Privacy Policy") {}
        ResendTimer("Resend in 00:42")
    }
    .padding(Spacing.xl)
    .background(Colors.onboardingGradient)
}
