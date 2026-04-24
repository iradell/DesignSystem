import SwiftUI

// MARK: - Button Style

public enum DSButtonStyle {
    case dark
    case gradient
}

// MARK: - Primary Button

public struct DSPrimaryButton: View {
    private let title: String
    private let style: DSButtonStyle
    private let icon: Image?
    private let action: () -> Void

    public init(
        _ title: String,
        style: DSButtonStyle = .dark,
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
            HStack(spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSTypography.buttonPrimary)
                    .foregroundStyle(DSColors.textOnDark)

                if let icon {
                    icon
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(DSColors.textOnDark)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.lg)
            .padding(.horizontal, DSSpacing.xxl)
            .background(backgroundView)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .dark:
            RoundedRectangle(cornerRadius: .infinity)
                .fill(DSColors.bgDark)
        case .gradient:
            RoundedRectangle(cornerRadius: DSRadius.lg)
                .fill(DSColors.primaryButtonGradient)
        }
    }
}

// MARK: - Secondary Button

public struct DSSecondaryButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypography.buttonSecondary)
                .foregroundStyle(DSColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DSSpacing.xs)
                .opacity(0.6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Back Button

public struct DSBackButton: View {
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
                .foregroundStyle(DSColors.textPrimary)
                .frame(width: size, height: size)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(DSColors.glassBorderStrong, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Social Button

public enum DSSocialProvider: String, CaseIterable, Sendable {
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

public struct DSSocialButton: View {
    private let provider: DSSocialProvider
    private let showLabel: Bool
    private let action: () -> Void

    public init(
        provider: DSSocialProvider,
        showLabel: Bool = true,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.showLabel = showLabel
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.sm) {
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
                        .font(DSTypography.labelLarge)
                        .foregroundStyle(DSColors.textPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .stroke(DSColors.glassBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Action Button (Answer Now style)

public struct DSActionButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypography.buttonAction)
                .foregroundStyle(DSColors.textOnDark)
                .padding(.horizontal, 28)
                .padding(.vertical, DSSpacing.sm)
                .background(DSColors.answerButtonGradient)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
                .shadow(color: DSColors.indigoGlow, radius: 15, y: 10)
                .shadow(color: DSColors.indigoGlow, radius: 6, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Primary Buttons") {
    VStack(spacing: 20) {
        DSPrimaryButton("Get Started", style: .dark) {}
        DSPrimaryButton("Continue", style: .gradient) {}
        DSPrimaryButton("Continue", style: .gradient, icon: Image(systemName: "arrow.right")) {}
    }
    .padding()
}

#Preview("Secondary & Back Buttons") {
    VStack(spacing: 20) {
        DSSecondaryButton("Already have an account? Log in") {}

        HStack {
            DSBackButton {}
            Spacer()
        }

        DSActionButton("Answer Now") {}
    }
    .padding()
    .background(DSColors.onboardingGradient)
}

#Preview("Social Buttons") {
    VStack(spacing: 20) {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(DSSocialProvider.allCases, id: \.self) { provider in
                DSSocialButton(provider: provider) {}
            }
        }

        HStack(spacing: 12) {
            ForEach(DSSocialProvider.allCases, id: \.self) { provider in
                DSSocialButton(provider: provider, showLabel: false) {}
            }
        }
    }
    .padding()
    .background(Color(hex: 0xF8F9FA))
}
