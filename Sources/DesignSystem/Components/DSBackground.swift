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
        // The app uses a single unified background everywhere — the lavender
        // "form" gradient. `.onboarding` is kept as an enum case for source
        // compatibility but routes to the same renderer so no screen can
        // accidentally diverge.
        formBackground
    }

    private var formBackground: some View {
        ZStack {
            Color(hex: 0xE8E9F4).ignoresSafeArea()

            // Top-left indigo glow
            RadialGradient(
                colors: [Color(hex: 0xC7D0FF), Color(hex: 0xC7D0FF).opacity(0)],
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Top-right violet glow
            RadialGradient(
                colors: [Color(hex: 0xD4CCFE), Color(hex: 0xD4CCFE).opacity(0)],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Bottom-right lavender glow
            RadialGradient(
                colors: [Color(hex: 0xE0DAFF), Color(hex: 0xE0DAFF).opacity(0)],
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

