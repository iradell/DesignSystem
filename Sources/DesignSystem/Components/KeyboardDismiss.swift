import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Keyboard input region

/// Preference key used by `markAsKeyboardInputRegion()` to publish the
/// global frame of every text-input region in a screen up to its
/// `dismissKeyboardOnBackgroundTap()` modifier. The modifier collects
/// these rects and skips dismissal for any tap that lands inside one of
/// them.
private struct KeyboardInputRegionsKey: PreferenceKey {
    static let defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

public extension View {
    /// Marks the modified view's bounds (in global coordinates) as a
    /// region where `.dismissKeyboardOnBackgroundTap()` must NOT fire.
    /// Apply this to any custom view that wraps a `TextField`,
    /// `SecureField`, or other input control — particularly when the
    /// visible tap target is larger than the underlying field's intrinsic
    /// frame, or when the underlying field is hidden / non-hit-testable
    /// (`.opacity(0)`, `.allowsHitTesting(false)`).
    ///
    /// The Design-System inputs `GlassTextField` and `OTPField` apply
    /// this internally; consumer-level call sites only need it on their
    /// own custom text-input wrappers.
    ///
    /// Mechanism: a transparent `GeometryReader` published in `.background`
    /// emits the view's global frame through a `PreferenceKey`. The
    /// `dismissKeyboardOnBackgroundTap()` modifier reads the accumulated
    /// preference and tests every tap location against it before deciding
    /// whether to resign the first responder.
    func markAsKeyboardInputRegion() -> some View {
        background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: KeyboardInputRegionsKey.self,
                    value: [proxy.frame(in: .global)]
                )
            }
        }
    }
}

// MARK: - Dismiss Keyboard On Background Tap

/// Dismisses the keyboard when the user taps anywhere on the modified
/// view *except* on a text input. Uses `SpatialTapGesture` to capture the
/// tap location and skips dismissal when the tap falls inside any region
/// published by `markAsKeyboardInputRegion()` from a descendant view.
///
/// Built-in `UITextField` / `UITextView` instances are also detected
/// directly by frame-walking the key window — so plain SwiftUI
/// `TextField`s without an explicit input-region marker are still handled
/// correctly. Custom components that need a larger tap area than their
/// underlying field's intrinsic frame must call
/// `markAsKeyboardInputRegion()` to declare it.
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
public extension View {
    func dismissKeyboardOnBackgroundTap() -> some View {
        modifier(DismissKeyboardOnBackgroundTapModifier())
    }
}

private struct DismissKeyboardOnBackgroundTapModifier: ViewModifier {
    @State private var inputRegions: [CGRect] = []

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(KeyboardInputRegionsKey.self) { regions in
                inputRegions = regions
            }
            .simultaneousGesture(
                SpatialTapGesture(coordinateSpace: .global)
                    .onEnded { event in
                        if shouldSkip(event.location) { return }
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
            )
    }

    private func shouldSkip(_ point: CGPoint) -> Bool {
        if inputRegions.contains(where: { $0.contains(point) }) { return true }
        return KeyboardDismiss.isLocationOnTextInput(point)
    }
}

private enum KeyboardDismiss {
    /// Fallback for plain SwiftUI text inputs that aren't wrapped by a
    /// component using `markAsKeyboardInputRegion()`. Walks the key
    /// window's view tree and returns `true` if any `UITextField` or
    /// `UITextView` has a frame (in window coordinates) containing
    /// `point`.
    static func isLocationOnTextInput(_ point: CGPoint) -> Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return false }

        return containsTextInput(in: window, at: point)
    }

    private static func containsTextInput(in view: UIView, at point: CGPoint) -> Bool {
        if view is UITextField || view is UITextView {
            let frameInWindow = view.convert(view.bounds, to: nil)
            if frameInWindow.contains(point) { return true }
        }
        for subview in view.subviews {
            if containsTextInput(in: subview, at: point) { return true }
        }
        return false
    }
}

#endif
