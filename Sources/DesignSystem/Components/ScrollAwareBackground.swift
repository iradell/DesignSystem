import SwiftUI

// MARK: - Scroll-Aware Navigation Background Modifier

/// A `ViewModifier` that transitions a view's background from fully transparent to a
/// frosted-glass material as the user scrolls.
///
/// Attach it to any header/navigation bar view. Drive the `scrollY` binding from an
/// `onScrollGeometryChange` listener on the corresponding `ScrollView`.
///
/// **Formula:** `opacity = min(1, max(0, scrollY / tolerance))`
///
/// At `scrollY == 0` the header is fully transparent — no material, no divider.
/// As the user scrolls the blur fades in, letting the gradient and content behind
/// the header show through with the frosted-glass effect rather than being covered
/// by a flat tint color.
///
/// - Parameters:
///   - scrollY: The current vertical scroll offset (pts from top). Sourced from
///     `onScrollGeometryChange { $0.contentOffset.y }` on the owning `ScrollView`.
///   - tolerance: How many points of scroll map to the full 0→1 opacity range.
///     Default `100` — opacity reaches 1 after 100 pts of scroll.
///   - material: The SwiftUI `Material` that fades in. Defaults to `.ultraThinMaterial`
///     — the lightest blur, which lets the gradient behind the header bleed through
///     without obscuring it. Pass `.thinMaterial`, `.regularMaterial`, etc. for a
///     stronger blur if the design calls for it.
///   - showDivider: When `true` a 1-pt divider fades in below the header alongside
///     the background, giving a subtle scroll-depth cue. Defaults to `true`.
///
/// **Usage:**
/// ```swift
/// HomeHeader(...)
///     .scrollAwareNavigationBackground(scrollY: $scrollY)
/// ```
public struct ScrollAwareNavigationBackground: ViewModifier {

    // MARK: Inputs

    private let scrollY: Binding<CGFloat>
    private let tolerance: CGFloat
    private let material: Material
    private let showDivider: Bool

    // MARK: Derived

    private var backgroundOpacity: Double {
        Double(min(1, max(0, scrollY.wrappedValue / tolerance)))
    }

    // MARK: Init

    public init(
        scrollY: Binding<CGFloat>,
        tolerance: CGFloat = 100,
        material: Material = .ultraThinMaterial,
        showDivider: Bool = true
    ) {
        self.scrollY = scrollY
        self.tolerance = tolerance
        self.material = material
        self.showDivider = showDivider
    }

    // MARK: Body

    public func body(content: Content) -> some View {
        content
            .background(alignment: .top) {
                Rectangle()
                    .fill(material)
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea(edges: .top)
                    .animation(.easeInOut(duration: 0.15), value: backgroundOpacity)
            }
            .overlay(alignment: .bottom) {
                if showDivider {
                    Rectangle()
                        .fill(Colors.divider)
                        .frame(height: 1)
                        .opacity(backgroundOpacity)
                        .animation(.easeInOut(duration: 0.15), value: backgroundOpacity)
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a scroll-aware navigation background that fades from fully transparent
    /// to a frosted-glass `material` as `scrollY` increases from 0 to `tolerance`.
    ///
    /// - Parameters:
    ///   - scrollY: Binding to the scroll offset updated via `onScrollGeometryChange`.
    ///   - tolerance: Points of scroll over which opacity transitions 0→1. Default `100`.
    ///   - material: SwiftUI `Material` to blur in. Default `.ultraThinMaterial`.
    ///   - showDivider: Whether to show a bottom divider that fades in with the background. Default `true`.
    public func scrollAwareNavigationBackground(
        scrollY: Binding<CGFloat>,
        tolerance: CGFloat = 100,
        material: Material = .ultraThinMaterial,
        showDivider: Bool = true
    ) -> some View {
        modifier(
            ScrollAwareNavigationBackground(
                scrollY: scrollY,
                tolerance: tolerance,
                material: material,
                showDivider: showDivider
            )
        )
    }
}

// MARK: - Preview

#Preview("Scroll-Aware Header Background") {
    struct PreviewWrapper: View {
        @State private var scrollY: CGFloat = 0

        var body: some View {
            ZStack(alignment: .top) {
                GradientBackground(style: .form)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.md) {
                        Color.clear.frame(height: Spacing.xxxxl + Spacing.md)

                        ForEach(0..<20, id: \.self) { i in
                            GlassCard {
                                Text("Row \(i + 1)")
                                    .font(Typography.bodyDefault)
                                    .foregroundStyle(Colors.textPrimary)
                            }
                            .padding(.horizontal, Spacing.xl)
                        }

                        Color.clear.frame(height: Spacing.xxxxl)
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    geo.contentOffset.y
                } action: { _, newY in
                    scrollY = max(0, newY)
                }

                HomeHeader(timerText: "01:24:12") {}
                    .scrollAwareNavigationBackground(scrollY: $scrollY)
            }
        }
    }

    return PreviewWrapper()
}
