import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Dismiss Keyboard On Background Tap

/// Dismisses the keyboard when the user taps anywhere on the modified
/// view *except* on a text input. Uses `SpatialTapGesture` to capture the
/// tap location, then runs a UIKit hit-test on the key window at that
/// point and walks the resulting view's ancestor chain looking for a
/// `UITextField` or `UITextView`. If one is found the dismiss is skipped,
/// so tapping a focused field doesn't cause it to resign-and-re-take
/// first responder (which produces a visible keyboard flicker).
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
    /// Returns `true` if a UIKit hit-test at `point` (in window/global
    /// coordinates) lands on, or inside, a `UITextField` or `UITextView`.
    /// Walks the hit view's superview chain so taps on subviews of a text
    /// input (e.g. its clear-button or selection handles) also count.
    static func isLocationOnTextInput(_ point: CGPoint) -> Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return false }

        var view: UIView? = window.hitTest(point, with: nil)
        while let current = view {
            if current is UITextField || current is UITextView { return true }
            view = current.superview
        }
        return false
    }
}

#endif
