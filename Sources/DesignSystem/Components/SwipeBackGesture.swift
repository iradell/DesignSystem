import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Swipe Back Gesture

/// Hiding the system navigation bar (`.toolbar(.hidden, for: .navigationBar)`,
/// used by screens that render their own DS header) disables
/// `UINavigationController.interactivePopGestureRecognizer` as a side
/// effect — its default wiring assumes the standard back button/bar is
/// present. This restores the edge-swipe-to-go-back gesture independent of
/// the hidden bar.
private final class SwipeBackGestureViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

private struct SwipeBackGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        SwipeBackGestureViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            uiViewController.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}

public extension View {
    /// Re-enables the interactive edge-swipe-to-go-back gesture on a
    /// pushed screen whose system navigation bar is hidden. Apply to the
    /// pushed destination's content, not the stack root (there's nothing
    /// behind a root to swipe back to).
    func enableSwipeBackGesture() -> some View {
        background(SwipeBackGestureEnabler())
    }
}
#endif
