import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Horizontal Pan Recognizer

/// A UIKit `UIPanGestureRecognizer` that refuses to begin unless the pan is
/// horizontal-dominant.
///
/// This exists because a SwiftUI `DragGesture` cannot express "only claim
/// horizontal drags". It *activates* as soon as the touch passes
/// `minimumDistance` in any direction — which cancels the enclosing
/// ScrollView's pan — and any direction check inside `onChanged` runs too
/// late to give the scroll back. `.simultaneousGesture` doesn't help either:
/// the scroll is already cancelled by the time our handler no-ops.
///
/// `gestureRecognizerShouldBegin` is the only hook that can decide *before*
/// claiming the touch, so vertical drags are never recognized here at all
/// and flow through to the ScrollView untouched.
private struct HorizontalPanRecognizer: UIViewRepresentable {
    let onChanged: (CGFloat) -> Void
    let onEnded: (CGFloat) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:))
        )
        pan.delegate = context.coordinator
        view.addGestureRecognizer(pan)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: HorizontalPanRecognizer

        init(_ parent: HorizontalPanRecognizer) {
            self.parent = parent
        }

        @objc func handlePan(_ pan: UIPanGestureRecognizer) {
            let dx = pan.translation(in: pan.view).x
            switch pan.state {
            case .changed:
                parent.onChanged(dx)
            case .ended, .cancelled, .failed:
                parent.onEnded(dx)
            default:
                break
            }
        }

        /// The whole point: claim the touch only when it's clearly sideways.
        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            guard let pan = recognizer as? UIPanGestureRecognizer else { return true }
            let velocity = pan.velocity(in: pan.view)
            return abs(velocity.x) > abs(velocity.y)
        }

        /// Let the ScrollView's own recognizer keep running alongside ours.
        func gestureRecognizer(
            _ recognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
        ) -> Bool {
            true
        }
    }
}

// MARK: - Swipe To Reply

/// Drag a chat bubble left-to-right to trigger a reply — the bubble
/// follows the finger up to a small max offset and springs back on
/// release; a reply arrow fades in at the bubble's original leading edge
/// as the drag crosses the trigger threshold. Works the same for sent and
/// received bubbles (both just get temporarily nudged rightward).
///
/// Vertical scrolling started on top of a bubble is unaffected — see
/// `HorizontalPanRecognizer` for why that needs a UIKit recognizer.
private struct SwipeToReplyModifier: ViewModifier {
    let onReply: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var hasTriggeredHaptic = false

    private let maxOffset: CGFloat = 56
    private let triggerThreshold: CGFloat = 44

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Image(systemName: "arrowshape.turn.up.left.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Colors.accentIndigo)
                .opacity(progress)
                .scaleEffect(0.5 + progress * 0.5)
                .padding(.leading, 6)

            content
                .offset(x: dragOffset)
        }
        // An overlay (rather than a background) so the recognizer's view is
        // reliably the hit-test target. Ancestor recognizers — including the
        // ScrollView's pan — still receive these touches, since UIKit
        // delivers touches to every recognizer along the hit view's
        // responder chain.
        .overlay(
            HorizontalPanRecognizer(
                onChanged: { dx in
                    dragOffset = min(max(0, dx), maxOffset)
                    let crossedThreshold = dragOffset >= triggerThreshold
                    if crossedThreshold, !hasTriggeredHaptic {
                        Haptics.impact(.light)
                        hasTriggeredHaptic = true
                    } else if !crossedThreshold {
                        hasTriggeredHaptic = false
                    }
                },
                onEnded: { dx in
                    if max(0, dx) >= triggerThreshold {
                        onReply()
                    }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        dragOffset = 0
                    }
                    hasTriggeredHaptic = false
                }
            )
        )
    }

    private var progress: CGFloat {
        min(1, dragOffset / triggerThreshold)
    }
}

extension View {
    /// Adds the "swipe right to reply" gesture used throughout the chat
    /// thread. Apply directly to a `ChatBubble` / `QuotedChatBubble`.
    public func swipeToReply(onReply: @escaping () -> Void) -> some View {
        modifier(SwipeToReplyModifier(onReply: onReply))
    }
}

// MARK: - Previews

#Preview("Swipe To Reply") {
    ScrollView {
        VStack(spacing: Spacing.lg) {
            ForEach(0..<12, id: \.self) { index in
                ChatBubble(
                    "Swipe me right to reply — and scrolling still works. (\(index))",
                    style: index.isMultiple(of: 2) ? .received : .sent,
                    timestamp: "1:12 PM"
                )
                .swipeToReply {}
            }
        }
        .padding(Spacing.xl)
    }
    .background(Color(hex: 0xF8F9FA))
}

#endif
