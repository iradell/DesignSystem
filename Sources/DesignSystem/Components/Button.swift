import SwiftUI

// MARK: - Button Style

public enum ButtonStyle {
    case dark
    case gradient
}

// MARK: - Primary Button

public struct PrimaryButton: View {
    private let title: String
    private let style: ButtonStyle
    private let icon: Image?
    private let action: () -> Void

    public init(
        _ title: String,
        style: ButtonStyle = .dark,
        icon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Text(title)
                    .font(Typography.buttonPrimary)
                    .foregroundStyle(Colors.textOnDark)

                if let icon {
                    icon
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Colors.textOnDark)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.lg)
            .padding(.horizontal, Spacing.xxl)
            .background(backgroundView)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .dark:
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Colors.bgDark)
        case .gradient:
            RoundedRectangle(cornerRadius: Radius.lg)
                .fill(Colors.primaryButtonGradient)
        }
    }
}

// MARK: - Secondary Button

public struct SecondaryButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.buttonSecondary)
                .foregroundStyle(Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xs)
                .opacity(0.6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Back Button

public struct BackButton: View {
    private let size: CGFloat
    private let action: () -> Void

    public init(size: CGFloat = 40, action: @escaping () -> Void) {
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Colors.textPrimary)
                .frame(width: size, height: size)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Colors.glassBorderStrong, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Social Button

public enum SocialProvider: String, CaseIterable, Sendable {
    case apple = "Apple"
    case google = "Google"
    case facebook = "Facebook"
    case twitter = "Twitter"

    public var assetName: String {
        switch self {
        case .apple: "brand_apple"
        case .google: "brand_google"
        case .facebook: "brand_facebook"
        case .twitter: "brand_twitter"
        }
    }
}

public struct SocialButton: View {
    private let provider: SocialProvider
    private let showLabel: Bool
    private let action: () -> Void

    public init(
        provider: SocialProvider,
        showLabel: Bool = true,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.showLabel = showLabel
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                Image(provider.assetName, bundle: .module)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: showLabel ? 20 : 24,
                        height: showLabel ? 20 : 24
                    )

                if showLabel {
                    Text(provider.rawValue)
                        .font(Typography.labelLarge)
                        .foregroundStyle(Colors.textPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Colors.glassBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Action Button (Answer Now style)

public struct ActionButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.buttonAction)
                .foregroundStyle(Colors.textOnDark)
                .padding(.horizontal, 28)
                .padding(.vertical, Spacing.sm)
                .background(Colors.answerButtonGradient)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                .shadow(color: Colors.indigoGlow, radius: 15, y: 10)
                .shadow(color: Colors.indigoGlow, radius: 6, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Primary Buttons") {
    VStack(spacing: 20) {
        PrimaryButton("Get Started", style: .dark) {}
        PrimaryButton("Continue", style: .gradient) {}
        PrimaryButton("Continue", style: .gradient, icon: Image(systemName: "arrow.right")) {}
    }
    .padding()
}

#Preview("Secondary & Back Buttons") {
    VStack(spacing: 20) {
        SecondaryButton("Already have an account? Log in") {}

        HStack {
            BackButton {}
            Spacer()
        }

        ActionButton("Answer Now") {}
    }
    .padding()
    .background(Colors.onboardingGradient)
}

#Preview("Social Buttons") {
    VStack(spacing: 20) {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(SocialProvider.allCases, id: \.self) { provider in
                SocialButton(provider: provider) {}
            }
        }

        HStack(spacing: 12) {
            ForEach(SocialProvider.allCases, id: \.self) { provider in
                SocialButton(provider: provider, showLabel: false) {}
            }
        }
    }
    .padding()
    .background(Color(hex: 0xF8F9FA))
}
