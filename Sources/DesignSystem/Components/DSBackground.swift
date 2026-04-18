import SwiftUI

// MARK: - Background Style

public enum DSBackgroundStyle {
    case onboarding
    case form
}

// MARK: - Gradient Background

public struct DSGradientBackground: View {
    private let style: DSBackgroundStyle

    public init(style: DSBackgroundStyle = .onboarding) {
        self.style = style
    }

    public var body: some View {
        switch style {
        case .onboarding:
            onboardingBackground
        case .form:
            formBackground
        }
    }

    private var onboardingBackground: some View {
        LinearGradient(
            colors: [Color(hex: 0xF2F2F7), Color(hex: 0xE5E7FF)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var formBackground: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // Top-left indigo glow
            RadialGradient(
                colors: [Color(hex: 0xE0E7FF), Color(hex: 0xE0E7FF).opacity(0)],
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Top-right purple glow
            RadialGradient(
                colors: [Color(hex: 0xF5D0FE), Color(hex: 0xF5D0FE).opacity(0)],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Bottom-right pink glow
            RadialGradient(
                colors: [Color(hex: 0xFDF4FF), Color(hex: 0xFDF4FF).opacity(0)],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Background Modifier

public struct DSBackgroundModifier: ViewModifier {
    private let style: DSBackgroundStyle

    public init(style: DSBackgroundStyle) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .background(DSGradientBackground(style: style))
    }
}

extension View {
    public func dsBackground(_ style: DSBackgroundStyle = .onboarding) -> some View {
        modifier(DSBackgroundModifier(style: style))
    }
}

// MARK: - Previews

#Preview("Onboarding Background") {
    Text("Onboarding")
        .font(DSTypography.headingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dsBackground(.onboarding)
}

#Preview("Form Background") {
    Text("Form Screen")
        .font(DSTypography.displayMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dsBackground(.form)
}
