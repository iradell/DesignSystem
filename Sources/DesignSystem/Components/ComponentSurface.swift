import SwiftUI

// MARK: - Component Surface Style
//
// The app's `GradientBackground(style: .form)` is the unified flow background.
// `bgLight` and the gradient's base are the same `#E8E9F4`, so naive cards
// using `bgLight` (or a near-white `#F8F9FA` like the existing previews use)
// either dissolve into the gradient or clash with it. These four candidates
// give every card a deliberate surface that sits on the gradient correctly.
//
// Pick one to standardise. The previews at the bottom render all four side
// by side against the *real* `GradientBackground(style: .form)`.

public enum ComponentSurfaceStyle: Sendable {
    /// Opaque white card. Substantial, neutral, works against any gradient.
    case solidWhite

    /// Refined `.ultraThinMaterial` glass with an indigo-tinted border.
    case glassRefined

    /// `.ultraThinMaterial` + 8% indigo wash — branded glass.
    case tintedIndigo

    /// Warm off-white solid (#FFFBF7) — paper card with subtle warmth.
    case cream
}

// MARK: - Component Surface Modifier

public struct ComponentSurfaceModifier: ViewModifier {
    private let style: ComponentSurfaceStyle
    private let radius: CGFloat

    public init(style: ComponentSurfaceStyle, radius: CGFloat) {
        self.style = style
        self.radius = radius
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        return content
            .background {
                ZStack {
                    if style == .glassRefined || style == .tintedIndigo {
                        shape.fill(.ultraThinMaterial)
                    }
                    shape.fill(topFill)
                }
            }
            .overlay {
                shape.strokeBorder(strokeColor, lineWidth: 1)
            }
            .clipShape(shape)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }

    // MARK: Style routing

    private var topFill: AnyShapeStyle {
        switch style {
        case .solidWhite:   return AnyShapeStyle(Colors.surfaceSolidWhiteFill)
        case .glassRefined: return AnyShapeStyle(Color.clear)
        case .tintedIndigo: return AnyShapeStyle(Colors.surfaceTintedIndigoWash)
        case .cream:        return AnyShapeStyle(Colors.surfaceCreamFill)
        }
    }

    private var strokeColor: Color {
        switch style {
        case .solidWhite:   return Colors.surfaceSolidWhiteStroke
        case .glassRefined: return Colors.surfaceGlassRefinedStroke
        case .tintedIndigo: return Colors.surfaceTintedIndigoStroke
        case .cream:        return Colors.surfaceCreamStroke
        }
    }

    private var shadowColor: Color {
        switch style {
        case .solidWhite:   return Color.black.opacity(0.06)
        case .glassRefined: return Colors.accentIndigo.opacity(0.08)
        case .tintedIndigo: return Colors.accentIndigo.opacity(0.12)
        case .cream:        return Color.black.opacity(0.04)
        }
    }

    private var shadowRadius: CGFloat {
        switch style {
        case .solidWhite:   return 8
        case .glassRefined: return 12
        case .tintedIndigo: return 10
        case .cream:        return 6
        }
    }

    private var shadowY: CGFloat {
        switch style {
        case .solidWhite:   return 2
        case .glassRefined: return 4
        case .tintedIndigo: return 4
        case .cream:        return 1
        }
    }
}

extension View {
    /// Apply one of the candidate component surface styles. The `.tintedIndigo`
    /// and `.glassRefined` cases layer themselves on top of `.ultraThinMaterial`
    /// to retain the existing blur — use `.componentSurfaceMaterial(...)` below
    /// for the full material+wash composition.
    public func componentSurface(
        _ style: ComponentSurfaceStyle,
        radius: CGFloat = Radius.xl
    ) -> some View {
        modifier(ComponentSurfaceModifier(style: style, radius: radius))
    }
}

// MARK: - Material-composed surface (for glass + wash combinations)
//
// `ComponentSurfaceModifier` keeps the simple "fill + stroke + shadow" API
// uniform. For the two glass styles we also want the underlying material,
// so this view wraps both fills into a single rounded card.

public struct SurfaceCard<Content: View>: View {
    private let style: ComponentSurfaceStyle
    private let radius: CGFloat
    private let padding: CGFloat
    private let content: Content

    public init(
        style: ComponentSurfaceStyle,
        radius: CGFloat = Radius.xl,
        padding: CGFloat = Spacing.lg,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        return content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    // Material under-layer for glass styles
                    if style == .glassRefined || style == .tintedIndigo {
                        shape.fill(.ultraThinMaterial)
                    }
                    // Top fill (tint / solid)
                    shape.fill(topFill)
                }
            }
            .overlay {
                shape.strokeBorder(strokeColor, lineWidth: 1)
            }
            .clipShape(shape)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }

    // MARK: Style routing

    private var topFill: AnyShapeStyle {
        switch style {
        case .solidWhite:   return AnyShapeStyle(Colors.surfaceSolidWhiteFill)
        case .glassRefined: return AnyShapeStyle(Color.clear)   // material only
        case .tintedIndigo: return AnyShapeStyle(Colors.surfaceTintedIndigoWash)
        case .cream:        return AnyShapeStyle(Colors.surfaceCreamFill)
        }
    }

    private var strokeColor: Color {
        switch style {
        case .solidWhite:   return Colors.surfaceSolidWhiteStroke
        case .glassRefined: return Colors.surfaceGlassRefinedStroke
        case .tintedIndigo: return Colors.surfaceTintedIndigoStroke
        case .cream:        return Colors.surfaceCreamStroke
        }
    }

    private var shadowColor: Color {
        switch style {
        case .solidWhite:   return Color.black.opacity(0.06)
        case .glassRefined: return Colors.accentIndigo.opacity(0.08)
        case .tintedIndigo: return Colors.accentIndigo.opacity(0.12)
        case .cream:        return Color.black.opacity(0.04)
        }
    }

    private var shadowRadius: CGFloat {
        switch style {
        case .solidWhite:   return 8
        case .glassRefined: return 12
        case .tintedIndigo: return 10
        case .cream:        return 6
        }
    }

    private var shadowY: CGFloat {
        switch style {
        case .solidWhite:   return 2
        case .glassRefined: return 4
        case .tintedIndigo: return 4
        case .cream:        return 1
        }
    }
}

// MARK: - Previews
//
// All four candidates rendered against the actual `GradientBackground(style: .form)`
// so you see exactly how they look in real Onboarding / flow context.

/// Side-by-side comparison of all four candidate surfaces.
#Preview("Surface candidates — over real gradient") {
    ZStack {
        GradientBackground(style: .form)

        ScrollView {
            VStack(spacing: Spacing.lg) {
                surfaceSample("1 · Solid White Card",
                              detail: "Color.white @ 85% · 4% black border · 6% black shadow",
                              style: .solidWhite)

                surfaceSample("2 · Frosted Glass (refined)",
                              detail: ".ultraThinMaterial · 12% indigo border · 8% indigo shadow",
                              style: .glassRefined)

                surfaceSample("3 · Tinted Indigo Glass",
                              detail: ".ultraThinMaterial + 8% indigo wash · 20% indigo border",
                              style: .tintedIndigo)

                surfaceSample("4 · Cream Card",
                              detail: "#FFFBF7 solid · #F0EEE8 border · 4% black shadow",
                              style: .cream)
            }
            .padding(Spacing.screenHorizontal)
        }
    }
}

/// Per-style preview — useful if you want to inspect one option full-screen.
#Preview("Solid White")    { surfaceFullScreen(.solidWhite,   label: "Solid White Card") }
#Preview("Glass Refined")  { surfaceFullScreen(.glassRefined, label: "Frosted Glass") }
#Preview("Tinted Indigo")  { surfaceFullScreen(.tintedIndigo, label: "Tinted Indigo Glass") }
#Preview("Cream")          { surfaceFullScreen(.cream,        label: "Cream Card") }

// MARK: Preview helpers

@MainActor @ViewBuilder
private func surfaceSample(
    _ title: String,
    detail: String,
    style: ComponentSurfaceStyle
) -> some View {
    SurfaceCard(style: style, radius: Radius.xl, padding: Spacing.lg) {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(Typography.headingMedium)
                .foregroundStyle(Colors.textPrimary)
            Text(detail)
                .font(Typography.bodySmall)
                .foregroundStyle(Colors.textSecondary)
        }
    }
}

@ViewBuilder
private func surfaceFullScreen(
    _ style: ComponentSurfaceStyle,
    label: String
) -> some View {
    ZStack {
        GradientBackground(style: .form)
        VStack(spacing: Spacing.lg) {
            SurfaceCard(style: style, radius: Radius.xl, padding: Spacing.xl) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(label)
                        .font(Typography.displaySmall)
                        .foregroundStyle(Colors.textPrimary)
                    Text("This is how a card on the unified flow background looks with this surface style. Headings, body copy, and secondary text should all stay legible.")
                        .font(Typography.bodyDefault)
                        .foregroundStyle(Colors.textSecondary)
                }
            }

            // Smaller card to see how a secondary surface stacks below it.
            SurfaceCard(style: style, radius: Radius.md, padding: Spacing.md) {
                Text("Secondary card · " + label)
                    .font(Typography.bodySmall)
                    .foregroundStyle(Colors.textSecondary)
            }
        }
        .padding(Spacing.screenHorizontal)
    }
}
