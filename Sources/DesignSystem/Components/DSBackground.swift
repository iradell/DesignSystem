import SwiftUI

// MARK: - Background Style

public enum DSBackgroundStyle {
    case onboarding
    case form
    case animatedMesh
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
        case .animatedMesh:
            DSAnimatedMeshBackground()
        }
    }

    private var onboardingBackground: some View {
        LinearGradient(
            colors: [Color(hex: 0xE8E9F4), Color(hex: 0xC7D0FF)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
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

// MARK: - Animated Mesh Background

public struct DSAnimatedMeshBackground: View {
    // Pale tokens — keep corners light so cards/text still read
    private let bgLight = Color(hex: 0xE8E9F4)
    private let palePink = Color(hex: 0xE0DAFF)
    private let paleBlue = Color(hex: 0xC7D0FF)

    // Saturated accents — drive the visible motion in the interior
    private let accentIndigo = Color(hex: 0x6366F1)
    private let accentPurple = Color(hex: 0x7C3AED)
    private let accentDeep   = Color(hex: 0x4F46E5)

    public init() {}

    public var body: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let p = phase(t)

            // sin everywhere → all moving points start exactly at 0.5 (no curvature on first frame).
            // Different multipliers per point so they desync and the motion reads as fluid, not pulsing.
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0],
                    [0.5 + 0.15 * Float(sin(p)),       0.0],
                    [1.0, 0.0],

                    [0.0, 0.5 + 0.15 * Float(sin(p * 0.9))],
                    [0.5 + 0.18 * Float(sin(p * 1.1)), 0.5 + 0.18 * Float(sin(p * 1.3))],
                    [1.0, 0.5 + 0.15 * Float(sin(p * 0.8))],

                    [0.0, 1.0],
                    [0.5 + 0.15 * Float(sin(p * 1.2)), 1.0],
                    [1.0, 1.0]
                ],
                colors: [
                    bgLight,        accentIndigo,  paleBlue,
                    accentPurple,   accentDeep,    accentIndigo,
                    paleBlue,       accentPurple,  palePink
                ],
                smoothsColors: true
            )
            .ignoresSafeArea()
        }
    }

    private func phase(_ t: TimeInterval) -> Double {
        // ~14s loop — calm, ambient motion.
        (t.truncatingRemainder(dividingBy: 14)) / 14 * .pi * 2
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

#Preview("Animated Mesh Background") {
    Text("Animated Mesh")
        .font(DSTypography.displayMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dsBackground(.animatedMesh)
}
