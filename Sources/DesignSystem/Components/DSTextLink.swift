import SwiftUI

// MARK: - Text Link

public struct DSTextLink: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(DSTypography.labelMedium)
                .foregroundStyle(DSColors.accentIndigo)
                .tracking(1.2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Resend Timer

public struct DSResendTimer: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text.uppercased())
            .font(DSTypography.labelMedium)
            .foregroundStyle(DSColors.accentIndigo)
            .tracking(1.2)
    }
}

// MARK: - Previews

#Preview("Text Link & Resend Timer") {
    VStack(spacing: 20) {
        DSTextLink("Forgot Password?") {}
        DSTextLink("Terms & Privacy Policy") {}
        DSResendTimer("Resend in 00:42")
    }
    .padding(DSSpacing.xl)
    .background(DSColors.onboardingGradient)
}
