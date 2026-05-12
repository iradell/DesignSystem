import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Coordinate space

/// Private named coordinate space established by
/// `dismissKeyboardOnBackgroundTap()`. Both the published input-region
/// rects (via `markAsKeyboardInputRegion`) and the dismiss tap-gesture
/// location are resolved against this name, which guarantees they share
/// the same origin.
///
/// Why this matters: `proxy.frame(in: .global)` and a `SpatialTapGesture`
/// with `coordinateSpace: .global` can drift by a small offset inside a
/// NavigationStack / safe-area / `UIHostingController` configuration —
/// the geometry "global" is measured against the window while the
/// gesture "global" can resolve against the hosting view. The drift is
/// often only a handful of points but is enough that a tap on the very
/// edge of a published rect falls *outside* it, causing the keyboard to
/// dismiss-and-reappear right at the field's border. Using a named
/// space we control eliminates the drift.
private let keyboardDismissAreaName = "DesignSystem.KeyboardDismissArea"

// MARK: - Keyboard input region

/// Preference key used by `markAsKeyboardInputRegion()` to publish the
/// frame of every text-input region (in the dismiss-area's named
/// coordinate space) up to its `dismissKeyboardOnBackgroundTap()`
/// modifier. The modifier collects these rects and skips dismissal for
/// any tap that lands inside one of them.
private struct KeyboardInputRegionsKey: PreferenceKey {
    static let defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

public extension View {
    /// Marks the modified view's bounds as a region where
    /// `.dismissKeyboardOnBackgroundTap()` must NOT fire. Apply this to
    /// any custom view that wraps a `TextField`, `SecureField`, or other
    /// input control — particularly when the visible tap target is
    /// larger than the underlying field's intrinsic frame, or when the
    /// underlying field is hidden / non-hit-testable (`.opacity(0)`,
    /// `.allowsHitTesting(false)`).
    ///
    /// The Design-System inputs `GlassTextField` and `OTPField` apply
    /// this internally; consumer-level call sites only need it on their
    /// own custom text-input wrappers.
    ///
    /// Mechanism: a transparent `GeometryReader` published in
    /// `.background` emits the view's frame, expressed in the named
    /// coordinate space established by the nearest
    /// `dismissKeyboardOnBackgroundTap()` ancestor. The dismiss modifier
    /// reads the accumulated preference and tests every tap location
    /// (also in that named space) against it before deciding whether
    /// to resign the first responder.
    func markAsKeyboardInputRegion() -> some View {
        background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: KeyboardInputRegionsKey.self,
                    value: [proxy.frame(in: .named(keyboardDismissAreaName))]
                )
            }
        }
    }
}

// MARK: - Dismiss Keyboard On Background Tap

/// Dismisses the keyboard when the user taps anywhere on the modified
/// view *except* on a text input. Uses `SpatialTapGesture` to capture
/// the tap location and skips dismissal when the tap falls inside any
/// region published by `markAsKeyboardInputRegion()` from a descendant
/// view.
///
/// Buttons, scroll-view pans, and other non-text interactions are
/// unaffected: `.simultaneousGesture` observes the tap alongside their
/// own gestures rather than competing with them.
///
/// **Usage:**
/// ```swift
/// VStack { ... }
///     .dismissKeyboardOnBackgroundTap()
/// ```
///
/// Any custom view wrapping a text input that this modifier should not
/// dismiss on must apply `.markAsKeyboardInputRegion()` to declare its
/// tap-claim area. Plain SwiftUI `TextField`s used outside the Design
/// System should also be marked.
public extension View {
    func dismissKeyboardOnBackgroundTap() -> some View {
        modifier(DismissKeyboardOnBackgroundTapModifier())
    }
}

private struct DismissKeyboardOnBackgroundTapModifier: ViewModifier {
    @State private var inputRegions: [CGRect] = []

    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: keyboardDismissAreaName)
            .onPreferenceChange(KeyboardInputRegionsKey.self) { regions in
                inputRegions = regions
            }
            .simultaneousGesture(
                SpatialTapGesture(coordinateSpace: .named(keyboardDismissAreaName))
                    .onEnded { event in
                        if inputRegions.contains(where: { $0.contains(event.location) }) {
                            return
                        }
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
            )
    }
}

#endif
