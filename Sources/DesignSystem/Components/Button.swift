import SwiftUI

// MARK: - Button Style

public enum ButtonStyle: Sendable {
    case dark
    case gradient
}

// MARK: - Primary Button

/// Primary CTA — solid indigo with a layered drop shadow.
///
/// Visual spec (Figma `LoginProposedV3` `Button:Sign In`):
/// - Fill: `#6366F1`
/// - Radius: 20pt
/// - Padding: 16pt vertical, fills parent width
/// - Label: Plus Jakarta Sans SemiBold 18pt, white
/// - Shadow stack: `0 20 25 -5 rgba(0,0,0,0.10)`, `0 8 10 -6 rgba(0,0,0,0.10)`
public struct PrimaryButton: View {
    private let title: String
    private let style: ButtonStyle
    private let icon: Image?
    private let action: () -> Void

    public init(
        _ title: String,
        style: ButtonStyle = .gradient,
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
            .padding(.vertical, Spacing.md)
            .padding(.horizontal, Spacing.xxl)
            .background(backgroundView)
            .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: 14)
            .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .dark:
            RoundedRectangle(cornerRadius: Radius.button, style: .continuous)
                .fill(Colors.bgDark)
        case .gradient:
            // Spec is now solid indigo. The enum case name is kept for
            // backward compat with existing callers.
            RoundedRectangle(cornerRadius: Radius.button, style: .continuous)
                .fill(Colors.accentIndigo)
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

/// Circular glass back/close button — uses the layered Liquid Glass
/// surface from `LiquidGlass.swift` (frost + color-burn + darken + system
/// material) so it reads consistently on any background.
public struct BackButton: View {
    private let size: CGFloat
    private let systemImage: String
    private let action: () -> Void

    public init(
        size: CGFloat = 44,
        systemImage: String = "chevron.left",
        action: @escaping () -> Void
    ) {
        self.size = size
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Colors.textPrimary)
                .frame(width: size, height: size)
                .liquidGlass(shape: Circle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Icon Button (glass pill)

/// Generic icon button rendered as a glass pill — matches the social-row
/// buttons in `LoginProposedV3`. Pass any view (SF Symbol, brand asset)
/// as the label.
public struct IconButton<Label: View>: View {
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let action: () -> Void
    private let label: () -> Label

    public init(
        height: CGFloat = 56,
        cornerRadius: CGFloat = 32,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .liquidGlass(
                    shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
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

/// Glass-pill social sign-in button. Default (no label) form matches the
/// 4-up row in `LoginProposedV3`: 56pt tall, 32pt radius, layered glass
/// surface. The labeled variant keeps the legacy stacked layout for
/// scenes that still use it.
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
        IconButton(
            height: 56,
            cornerRadius: 32,
            action: action
        ) {
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
        }
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
                .background(Colors.accentIndigo)
                .clipShape(RoundedRectangle(cornerRadius: Radius.button, style: .continuous))
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
        PrimaryButton("Sign In", style: .gradient) {}
        PrimaryButton("Continue", style: .gradient, icon: Image(systemName: "arrow.right")) {}
    }
    .padding(32)
    .background(.onboarding)
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
    .padding(32)
    .background(.onboarding)
}

#Preview("Social Row") {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            ForEach(SocialProvider.allCases, id: \.self) { provider in
                SocialButton(provider: provider, showLabel: false) {}
            }
        }
    }
    .padding(32)
    .background(.onboarding)
}
