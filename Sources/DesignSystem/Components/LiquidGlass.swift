import SwiftUI

// MARK: - Liquid Glass

/// Layered surface that approximates the Figma `Liquid Glass` material
/// (frost-base ▸ color-burn wash ▸ darken tint ▸ system material).
///
/// Use via the `.liquidGlass(shape:)` view modifier. The shape parameter
/// controls clipping & shadow casting — pass any `InsettableShape`
/// (Circle, Capsule, RoundedRectangle…).
public struct LiquidGlassBackground<S: InsettableShape>: View {
    private let shape: S

    public init(shape: S) {
        self.shape = shape
    }

    public var body: some View {
        ZStack {
            // System frosted material — provides true backdrop refraction.
            shape.fill(.regularMaterial)

            // White wash @ 65% — the bright base of the Figma layer stack.
            shape.fill(Colors.glassFrostBase)

            // Subtle warm color-burn — darkens highlights into a warm grey.
            shape
                .fill(Colors.glassFrostBurn)
                .blendMode(.colorBurn)
                .opacity(0.35)

            // Darken tint — pulls mid-tones into a soft warm cream.
            shape
                .fill(Colors.glassFrostDarken)
                .blendMode(.darken)
        }
        .compositingGroup()
    }
}

extension View {
    /// Applies the Liquid Glass surface treatment behind this view.
    /// - Parameters:
    ///   - shape: Any insettable shape — typically `Circle()`, `Capsule()`,
    ///     or `RoundedRectangle(cornerRadius: …)`.
    ///   - shadow: Drop-shadow style. Defaults to the standard token.
    public func liquidGlass<S: InsettableShape>(
        shape: S,
        shadow: LiquidGlassShadow = .standard
    ) -> some View {
        self
            .background(LiquidGlassBackground(shape: shape))
            .clipShape(shape)
            .shadow(color: shadow.color, radius: shadow.radius, x: 0, y: shadow.y)
    }
}

public struct LiquidGlassShadow: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.y = y
    }

    /// Figma token: `0 8 40 rgba(0,0,0,0.12)`.
    public static let standard = LiquidGlassShadow(
        color: Colors.glassShadow,
        radius: 20,
        y: 8
    )

    /// Softer ambient shadow for static surfaces.
    public static let soft = LiquidGlassShadow(
        color: Colors.glassShadowSoft,
        radius: 12,
        y: 4
    )

    /// No shadow.
    public static let hidden = LiquidGlassShadow(
        color: .clear,
        radius: 0,
        y: 0
    )
}

// MARK: - Previews

#Preview("Liquid Glass shapes") {
    ZStack {
        Colors.bgGlowIndigo.opacity(0.3).ignoresSafeArea()

        VStack(spacing: 24) {
            HStack(spacing: 16) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Colors.textPrimary)
                    .frame(width: 44, height: 44)
                    .liquidGlass(shape: Circle())

                Image(systemName: "ellipsis")
                    .foregroundStyle(Colors.textPrimary)
                    .frame(width: 56, height: 56)
                    .liquidGlass(shape: RoundedRectangle(cornerRadius: 32, style: .continuous))
            }

            HStack {
                Image(systemName: "apple.logo")
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .liquidGlass(shape: RoundedRectangle(cornerRadius: 32, style: .continuous))
                Image(systemName: "envelope")
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .liquidGlass(shape: RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            .padding(.horizontal, 24)
        }
    }
}
