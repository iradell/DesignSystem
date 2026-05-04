import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Dismiss Keyboard On Background Tap

/// Adds a transparent background tap recognizer that resigns the first
/// responder — i.e., dismisses the keyboard — when the user taps in any
/// empty area of the modified view.
///
/// The recognizer is attached as a `.background` so it only fires for taps
/// in regions where the foreground hierarchy has no hit-testable content.
/// Buttons, text inputs, and other interactive views still receive their
/// taps normally and are not interfered with.
///
/// **Usage:**
/// ```swift
/// VStack { ... }
///     .dismissKeyboardOnBackgroundTap()
/// ```
public extension View {
    func dismissKeyboardOnBackgroundTap() -> some View {
        background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
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
