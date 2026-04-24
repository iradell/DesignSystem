import SwiftUI

// `.topBarLeading`, `.topBarTrailing`, and `for: .navigationBar` are iOS-only
// SDK symbols with no macOS equivalent at any version. `@available(macOS …)`
// cannot help because the symbols are absent from the macOS SDK entirely —
// the compiler would still reject them at the use site. Wrapping the whole
// file in `#if os(iOS)` is the correct fix: the compiler simply never sees
// this code when building for macOS, eliminating the diagnostic at its source.

#if os(iOS)

// MARK: - Navigation Bar Modifier

/// A `ViewModifier` that configures the system `NavigationBar` to match the
/// `DSNavigationHeader` visual exactly:
/// - Hides the system back button and replaces it with `DSBackButton` in the
///   leading toolbar slot.
/// - Renders an optional inline title using `DSTypography.labelSmall` /
///   `tracking(2)` in the principal slot (matching the center slot of
///   `DSNavigationHeader`).
/// - Accepts an optional trailing `@ViewBuilder` for the trailing slot.
/// - Keeps the toolbar background transparent to let the gradient behind it
///   show through, matching the old header's `DSColors.onboardingGradient` look.
/// - Drives back navigation through the supplied `onBack` closure so the MVI
///   intent path (`viewModel.send(.tapBack)`) is preserved end-to-end.
///
/// **Usage:**
/// ```swift
/// MyView()
///     .dsNavigationBar(onBack: { viewModel.send(.tapBack) })
///
/// MyView()
///     .dsNavigationBar(title: "STEP 1 OF 3", onBack: { viewModel.send(.tapBack) })
///
/// MyView()
///     .dsNavigationBar(onBack: { viewModel.send(.tapBack) }) {
///         Button("Skip") { viewModel.send(.tapSkip) }
///     }
/// ```
public struct DSNavigationBarModifier<TrailingContent: View>: ViewModifier {

    // MARK: Inputs

    private let title: String?
    private let onBack: (() -> Void)?
    private let trailingContent: TrailingContent

    // MARK: Init

    public init(
        title: String?,
        onBack: (() -> Void)?,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.title = title
        self.onBack = onBack
        self.trailingContent = trailing()
    }

    // MARK: Body

    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Leading: DS-styled back button
                if let onBack {
                    ToolbarItem(placement: .topBarLeading) {
                        DSBackButton(action: onBack)
                    }
                }

                // Principal: optional uppercase tracking title
                if let title, !title.isEmpty {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(DSTypography.labelSmall)
                            .foregroundStyle(DSColors.textSecondary)
                            .tracking(2)
                    }
                }

                // Trailing: caller-supplied content
                ToolbarItem(placement: .topBarTrailing) {
                    trailingContent
                }
            }
            // Keep the toolbar area fully transparent so the page gradient
            // shows through behind the back button — matching the look of
            // DSNavigationHeader which rendered directly over the gradient.
            .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - View Extensions

extension View {
    /// Configures the system navigation bar to match the DS onboarding
    /// chrome: transparent background, `DSBackButton` in the leading slot,
    /// and an optional principal title.
    ///
    /// - Parameters:
    ///   - title: Uppercase tracking label rendered in the principal toolbar
    ///     slot (e.g. `"STEP 1 OF 3"`). Pass `nil` (default) for no title.
    ///   - onBack: Closure invoked when the back button is tapped. Pass `nil`
    ///     to suppress the back button entirely (use on the stack root).
    public func dsNavigationBar(
        title: String? = nil,
        onBack: (() -> Void)? = nil
    ) -> some View {
        modifier(
            DSNavigationBarModifier(title: title, onBack: onBack) {
                EmptyView()
            }
        )
    }

    /// Configures the system navigation bar with a trailing toolbar item.
    ///
    /// - Parameters:
    ///   - title: Uppercase tracking label in the principal slot. Default `nil`.
    ///   - onBack: Back button action. Pass `nil` to omit the back button.
    ///   - trailing: View placed in the trailing toolbar slot.
    public func dsNavigationBar<Trailing: View>(
        title: String? = nil,
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        modifier(
            DSNavigationBarModifier(title: title, onBack: onBack, trailing: trailing)
        )
    }
}

// MARK: - Preview

#Preview("DS Navigation Bar — variants") {
    NavigationStack {
        List(0..<20, id: \.self) { i in
            Text("Row \(i)")
        }
        .dsNavigationBar(title: "STEP 1 OF 3", onBack: {})
        .dsBackground(.onboarding)
    }
}

#Preview("DS Navigation Bar — trailing action") {
    NavigationStack {
        List(0..<20, id: \.self) { i in
            Text("Row \(i)")
        }
        .dsNavigationBar(onBack: {}) {
            Button("Skip") {}
                .font(DSTypography.buttonSmall)
                .foregroundStyle(DSColors.textSecondary)
        }
        .dsBackground(.onboarding)
    }
}

#endif // os(iOS)
