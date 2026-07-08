import SwiftUI

// MARK: - Background Style

public enum BackgroundStyle: Sendable {
    case onboarding
    case form
}

// MARK: - Gradient Background

/// The app's unified background: clean white surface with a soft pastel
/// glow in the upper region — modeled on the Figma `LoginProposedV3`
/// `Background Shadow` asset (a diffused indigo-violet radial splash).
///
/// `BackgroundStyle` cases are kept for source compatibility but all
/// route to the same renderer so screens can't accidentally diverge.
public struct GradientBackground: View {
    private let style: BackgroundStyle

    public init(style: BackgroundStyle = .onboarding) {
        self.style = style
    }

    public var body: some View {
        ZStack {
            Colors.bgPrimary.ignoresSafeArea()

            // Soft indigo splash anchored to the top-right (matches the
            // diffused glow visible above the heading in the Figma frame).
            RadialGradient(
                colors: [
                    Colors.bgGlowIndigo.opacity(0.55),
                    Colors.bgGlowIndigo.opacity(0)
                ],
                center: UnitPoint(x: 0.85, y: 0.05),
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()

            // Cooler violet tint behind the heading — broadens the glow
            // so it doesn't read as a single hotspot.
            RadialGradient(
                colors: [
                    Colors.bgGlowViolet.opacity(0.35),
                    Colors.bgGlowViolet.opacity(0)
                ],
                center: UnitPoint(x: 0.15, y: 0.1),
                startRadius: 0,
                endRadius: 320
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Background Modifier

public struct BackgroundModifier: ViewModifier {
    private let style: BackgroundStyle

    public init(style: BackgroundStyle) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .background(GradientBackground(style: style))
    }
}

extension View {
    public func background(_ style: BackgroundStyle = .onboarding) -> some View {
        modifier(BackgroundModifier(style: style))
    }
}

// MARK: - Previews

#Preview("Onboarding Background") {
    Text("Onboarding")
        .font(Typography.displayMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.onboarding)
}

#Preview("Form Background") {
    Text("Form Screen")
        .font(Typography.displayMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.form)
}
