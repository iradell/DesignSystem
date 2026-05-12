import SwiftUI

// `.topBarLeading`, `.topBarTrailing`, and `for: .navigationBar` are iOS-only
// SDK symbols with no macOS equivalent at any version. `@available(macOS …)`
// cannot help because the symbols are absent from the macOS SDK entirely —
// the compiler would still reject them at the use site. Wrapping the whole
// file in `#if os(iOS)` is the correct fix: the compiler simply never sees
// this code when building for macOS, eliminating the diagnostic at its source.

#if os(iOS)

// MARK: - Stack Root Environment Key

/// Marks the view as the root of its enclosing `NavigationStack`. When `true`,
/// `NavigationBarModifier` automatically suppresses its leading back button —
/// because there is nothing behind a stack root to navigate back to.
///
/// Set via `.markAsStackRoot()` on the root content of every coordinator's
/// `withNavigation(...)` call. Pushed destinations rendered via
/// `.navigationDestination` are siblings of the marked content rather than
/// descendants, so they do not inherit the flag and their back buttons render
/// normally.
private struct IsStackRootKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    var isStackRoot: Bool {
        get { self[IsStackRootKey.self] }
        set { self[IsStackRootKey.self] = newValue }
    }
}

public extension View {
    /// Marks this view as the root of its enclosing `NavigationStack`. Causes
    /// `.navigationBar(onBack:)` to omit the back button automatically.
    func markAsStackRoot() -> some View {
        environment(\.isStackRoot, true)
    }
}

// MARK: - Navigation Bar Modifier

/// A `ViewModifier` that hides the system `NavigationBar` entirely and
/// renders a Design-System onboarding header in its place — `BackButton`
/// (leading), optional uppercase title (centre), and an optional
/// trailing slot. The header is mounted via `.safeAreaInset(edge: .top)`
/// so the screen content is laid out below it without overlapping.
///
/// Why we don't use the system toolbar: on iOS 26 every `ToolbarItem`
/// in the navigation bar gets an automatic Liquid Glass capsule applied
/// behind its content. That capsule stacks behind `BackButton`'s own
/// glass treatment and produces a visible double-chrome artifact.
/// Driving the chrome ourselves removes the dependence on whatever the
/// system happens to do with toolbar items in any given iOS version.
///
/// Back navigation is still routed through the supplied `onBack` closure
/// so the MVI intent path (`viewModel.send(.tapBack)`) is preserved
/// end-to-end.
///
/// **Usage:**
/// ```swift
/// MyView()
///     .navigationBar(onBack: { viewModel.send(.tapBack) })
///
/// MyView()
///     .navigationBar(title: "STEP 1 OF 3", onBack: { viewModel.send(.tapBack) })
///
/// MyView()
///     .navigationBar(onBack: { viewModel.send(.tapBack) }) {
///         Button("Skip") { viewModel.send(.tapSkip) }
///     }
/// ```
public struct NavigationBarModifier<TrailingContent: View>: ViewModifier {

    // MARK: Inputs

    private let title: String?
    private let onBack: (() -> Void)?
    private let trailingContent: TrailingContent

    @Environment(\.isStackRoot) private var isStackRoot

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
        // Suppress the back button when the view is marked as the root of its
        // NavigationStack — there is nothing behind it to navigate back to.
        let resolvedOnBack: (() -> Void)? = isStackRoot ? nil : onBack

        return content
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                header(onBack: resolvedOnBack)
            }
    }

    private func header(onBack: (() -> Void)?) -> some View {
        ZStack {
            // Side slots own the row's width; the title is overlaid in
            // a parallel ZStack child so it stays geometrically centred
            // regardless of how wide leading/trailing end up.
            HStack(spacing: 0) {
                if let onBack {
                    BackButton(action: onBack)
                }
                Spacer(minLength: 0)
                trailingContent
            }

            if let title, !title.isEmpty {
                Text(title)
                    .font(Typography.labelSmall)
                    .foregroundStyle(Colors.textSecondary)
                    .tracking(2)
            }
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - View Extensions

extension View {
    /// Renders the DS onboarding header at the top of the screen and
    /// hides the system navigation bar. See `NavigationBarModifier`.
    ///
    /// - Parameters:
    ///   - title: Uppercase tracking label rendered in the centre of the
    ///     header (e.g. `"STEP 1 OF 3"`). Pass `nil` (default) for no
    ///     title.
    ///   - onBack: Closure invoked when the back button is tapped. Pass
    ///     `nil` to suppress the back button entirely (or call
    ///     `.markAsStackRoot()` on the stack's root view to suppress it
    ///     automatically).
    public func navigationBar(
        title: String? = nil,
        onBack: (() -> Void)? = nil
    ) -> some View {
        modifier(
            NavigationBarModifier(title: title, onBack: onBack) {
                EmptyView()
            }
        )
    }

    /// Renders the DS onboarding header with a trailing slot.
    ///
    /// - Parameters:
    ///   - title: Uppercase tracking label rendered in the centre. Default `nil`.
    ///   - onBack: Back button action. Pass `nil` to omit the back button.
    ///   - trailing: View placed in the trailing slot of the header.
    public func navigationBar<Trailing: View>(
        title: String? = nil,
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        modifier(
            NavigationBarModifier(title: title, onBack: onBack, trailing: trailing)
        )
    }
}

// MARK: - Preview

#Preview("DS Navigation Bar — variants") {
    NavigationStack {
        List(0..<20, id: \.self) { i in
            Text("Row \(i)")
        }
        .navigationBar(title: "STEP 1 OF 3", onBack: {})
        .background(.onboarding)
    }
}

#Preview("DS Navigation Bar — trailing action") {
    NavigationStack {
        List(0..<20, id: \.self) { i in
            Text("Row \(i)")
        }
        .navigationBar(onBack: {}) {
            Button("Skip") {}
                .font(Typography.buttonSmall)
                .foregroundStyle(Colors.textSecondary)
        }
        .background(.onboarding)
    }
}

#endif // os(iOS)
