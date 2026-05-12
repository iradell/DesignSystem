import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Dismiss Keyboard On Background Tap

/// Dismisses the keyboard when the user taps anywhere on the modified
/// view *except* on a text input. Uses `SpatialTapGesture` to capture the
/// tap location, then walks the entire key-window view hierarchy looking
/// for a `UITextField` or `UITextView` whose frame contains that point.
/// If one is found the dismiss is skipped, so tapping a focused field
/// doesn't cause it to resign-and-re-take first responder (which produces
/// a visible keyboard flicker).
///
/// We walk the hierarchy by frame intersection rather than relying on
/// `hitTest(_:with:)` so that hidden-but-positioned text inputs are still
/// detected. Custom components like `OTPField` host a real `TextField`
/// behind a stack of digit boxes with `.allowsHitTesting(false)` and
/// `.opacity(0)`, which makes `hitTest` skip them — but the frame-walk
/// still finds them and treats taps on the surrounding component as
/// "tap on a text input".
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
        simultaneousGesture(
            SpatialTapGesture(coordinateSpace: .global)
                .onEnded { event in
                    guard !KeyboardDismiss.isLocationOnTextInput(event.location) else {
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

private enum KeyboardDismiss {
    /// Returns `true` if any `UITextField` / `UITextView` anywhere in the
    /// key window has a frame (in window coordinates) that contains
    /// `point`. Recursively walks the full subview tree, so it finds even
    /// hidden / non-hit-testable text inputs that custom components stash
    /// behind their visual chrome.
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
