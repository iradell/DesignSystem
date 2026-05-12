import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Dismiss Keyboard On Background Tap

/// Hosts a UIKit `UITapGestureRecognizer` attached to a transparent UIView
/// placed as a SwiftUI background. The recognizer uses
/// `cancelsTouchesInView = false` so it observes every tap in the host's
/// bounds *without* swallowing the touch — the same tap still propagates
/// to whatever SwiftUI view is in front, so buttons, text fields, scroll
/// gestures, etc. continue to behave exactly as before.
///
/// This UIKit-based approach is used instead of a SwiftUI
/// `Color.clear.onTapGesture` background because the SwiftUI version is
/// fragile inside scroll views and gets blocked by opaque layers (other
/// `.background(...)`, materials, etc.) depending on modifier order and
/// iOS version. UIKit's gesture system attaches to the recognizer
/// directly and isn't affected by SwiftUI layering.
private struct KeyboardDismissTapHost: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject {
        @objc func handleTap() {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

/// Dismisses the keyboard whenever the user taps anywhere on the modified
/// view. Buttons, text inputs, and other interactive subviews still
/// receive their taps normally and are not interfered with — the
/// underlying UITapGestureRecognizer uses `cancelsTouchesInView = false`,
/// so every tap is observed for dismissal while continuing on to the
/// SwiftUI content.
///
/// **Usage:**
/// ```swift
/// VStack { ... }
///     .dismissKeyboardOnBackgroundTap()
/// ```
public extension View {
    func dismissKeyboardOnBackgroundTap() -> some View {
        background(KeyboardDismissTapHost())
    }
}

#endif
