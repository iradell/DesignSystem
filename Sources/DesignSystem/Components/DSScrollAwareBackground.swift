import SwiftUI

// MARK: - Scroll-Aware Navigation Background Modifier

/// A `ViewModifier` that transitions a view's background from fully transparent to a
/// solid color as the user scrolls.
///
/// Attach it to any header/navigation bar view. Drive the `scrollY` binding from an
/// `onScrollGeometryChange` listener on the corresponding `ScrollView`.
///
/// **Formula:** `opacity = min(1, max(0, scrollY / tolerance))`
///
/// - Parameters:
///   - scrollY: The current vertical scroll offset (pts from top). Sourced from
///     `onScrollGeometryChange { $0.contentOffset.y }` on the owning `ScrollView`.
///   - tolerance: How many points of scroll map to the full 0→1 opacity range.
///     Default `100` — opacity reaches 1 after 100 pts of scroll.
///   - color: The solid color the background fades to. Defaults to `DSColors.bgLightAlt`,
///     a near-white that matches the `form` gradient's base and keeps the header
///     legible without introducing a dark mode jump.
///   - showDivider: When `true` a 1-pt divider fades in below the header alongside
///     the background, giving a subtle scroll-depth cue. Defaults to `true`.
///
/// **Usage:**
/// ```swift
/// DSHomeHeader(...)
///     .dsScrollAwareNavigationBackground(scrollY: $scrollY)
/// ```
public struct DSScrollAwareNavigationBackground: ViewModifier {

    // MARK: Inputs

    private let scrollY: Binding<CGFloat>
    private let tolerance: CGFloat
    private let color: Color
    private let showDivider: Bool

    // MARK: Derived

    private var backgroundOpacity: Double {
        Double(min(1, max(0, scrollY.wrappedValue / tolerance)))
    }

    // MARK: Init

    public init(
        scrollY: Binding<CGFloat>,
        tolerance: CGFloat = 100,
        color: Color = DSColors.bgLightAlt,
        showDivider: Bool = true
    ) {
        self.scrollY = scrollY
        self.tolerance = tolerance
        self.color = color
        self.showDivider = showDivider
    }

    // MARK: Body

    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Material layer: fades in together with the solid tint so at
                    // scrollY == 0 the header is 100% transparent — no tint, no blur.
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(backgroundOpacity)

                    color
                        .opacity(backgroundOpacity)
                }
                .animation(.easeInOut(duration: 0.15), value: backgroundOpacity)
            )
            .overlay(alignment: .bottom) {
                if showDivider {
                    Rectangle()
                        .fill(DSColors.divider)
                        .frame(height: 1)
                        .opacity(backgroundOpacity)
                        .animation(.easeInOut(duration: 0.15), value: backgroundOpacity)
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a scroll-aware navigation background that fades from transparent to
    /// `color` as `scrollY` increases from 0 to `tolerance`.
    ///
    /// - Parameters:
    ///   - scrollY: Binding to the scroll offset updated via `onScrollGeometryChange`.
    ///   - tolerance: Points of scroll over which opacity transitions 0→1. Default `100`.
    ///   - color: Target background color. Default `DSColors.bgLightAlt`.
    ///   - showDivider: Whether to show a bottom divider that fades in with the background. Default `true`.
    public func dsScrollAwareNavigationBackground(
        scrollY: Binding<CGFloat>,
        tolerance: CGFloat = 100,
        color: Color = DSColors.bgLightAlt,
        showDivider: Bool = true
    ) -> some View {
        modifier(
            DSScrollAwareNavigationBackground(
                scrollY: scrollY,
                tolerance: tolerance,
                color: color,
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
                DSGradientBackground(style: .form)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DSSpacing.md) {
                        Color.clear.frame(height: DSSpacing.xxxxl + DSSpacing.md)

                        ForEach(0..<20, id: \.self) { i in
                            DSGlassCard {
                                Text("Row \(i + 1)")
                                    .font(DSTypography.bodyDefault)
                                    .foregroundStyle(DSColors.textPrimary)
                            }
                            .padding(.horizontal, DSSpacing.xl)
                        }

                        Color.clear.frame(height: DSSpacing.xxxxl)
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    geo.contentOffset.y
                } action: { _, newY in
                    scrollY = max(0, newY)
                }

                DSHomeHeader(timerText: "01:24:12") {}
                    .dsScrollAwareNavigationBackground(scrollY: $scrollY)
            }
        }
    }

    return PreviewWrapper()
}
