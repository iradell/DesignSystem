import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Dismiss Keyboard On Background Tap

/// Dismisses the keyboard whenever the user taps anywhere on the modified
/// view. Buttons, text inputs, and other interactive subviews still
/// receive their taps normally — the dismiss is attached via
/// `.simultaneousGesture`, which observes every tap *alongside* any
/// children's gestures rather than competing with them.
///
/// When a tap lands on a text input that's about to become focused (or is
/// already focused), iOS transfers first-responder state in the same
/// runloop tick, so the keyboard does not visibly dismiss-and-reappear.
/// Scroll-view pan gestures are unaffected because `TapGesture` only fires
/// on a discrete tap, not on a drag.
///
/// **Usage:**
/// ```swift
/// VStack { ... }
///     .dismissKeyboardOnBackgroundTap()
/// ```
public extension View {
    func dismissKeyboardOnBackgroundTap() -> some View {
        simultaneousGesture(
            TapGesture()
                .onEnded {
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
