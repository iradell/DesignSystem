import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Swipe Reply Direction

/// Which way a bubble is dragged to start a reply. Pick the one that pulls
/// the bubble away from the side it sits on — received bubbles drag right,
/// sent bubbles drag left.
public enum SwipeReplyDirection: Sendable {
    case leftToRight
    case rightToLeft

    fileprivate var sign: CGFloat {
        switch self {
        case .leftToRight: 1
        case .rightToLeft: -1
        }
    }
}

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
    /// Only pans travelling this way are claimed. Wrong-way swipes are left
    /// entirely alone, so e.g. the edge swipe-back gesture stays usable on a
    /// bubble that replies in the opposite direction.
    let allowedSign: CGFloat
    let onTap: (() -> Void)?
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

        // Taps are handled here rather than by a SwiftUI Button inside the
        // bubble: this view is the hit-test target for everything in the
        // bubble's frame, so a Button underneath it never receives the touch.
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap)
        )
        tap.delegate = context.coordinator
        view.addGestureRecognizer(tap)

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

        @objc func handleTap() {
            parent.onTap?()
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

        /// The whole point: claim the touch only when it's clearly sideways —
        /// and only when it's heading the way this bubble replies.
        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            // A tap only matters when someone is listening for it; otherwise
            // let it fall through untouched.
            if recognizer is UITapGestureRecognizer { return parent.onTap != nil }
            guard let pan = recognizer as? UIPanGestureRecognizer else { return true }
            let velocity = pan.velocity(in: pan.view)
            guard abs(velocity.x) > abs(velocity.y) else { return false }
            return velocity.x * parent.allowedSign > 0
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
    let direction: SwipeReplyDirection
    let onTap: (() -> Void)?
    let onReply: () -> Void

    /// Signed: positive when dragging right, negative when dragging left.
    @State private var dragOffset: CGFloat = 0
    @State private var hasTriggeredHaptic = false

    private let maxOffset: CGFloat = 56
    private let triggerThreshold: CGFloat = 44

    func body(content: Content) -> some View {
        ZStack(alignment: direction == .leftToRight ? .leading : .trailing) {
            Image(systemName: "arrowshape.turn.up.left.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Colors.accentIndigo)
                .opacity(progress)
                .scaleEffect(0.5 + progress * 0.5)
                .padding(direction == .leftToRight ? .leading : .trailing, 6)

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
                allowedSign: direction.sign,
                onTap: onTap,
                onChanged: { dx in
                    // Distance travelled the allowed way; wrong-way movement
                    // clamps to zero so the bubble never drags backwards.
                    let travel = min(max(0, dx * direction.sign), maxOffset)
                    dragOffset = travel * direction.sign

                    let crossedThreshold = travel >= triggerThreshold
                    if crossedThreshold, !hasTriggeredHaptic {
                        Haptics.impact(.light)
                        hasTriggeredHaptic = true
                    } else if !crossedThreshold {
                        hasTriggeredHaptic = false
                    }
                },
                onEnded: { dx in
                    if max(0, dx * direction.sign) >= triggerThreshold {
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
        min(1, abs(dragOffset) / triggerThreshold)
    }
}

extension View {
    /// Adds the swipe-to-reply gesture used throughout the chat thread.
    /// Apply directly to a `ChatBubble` / `QuotedChatBubble`.
    ///
    /// - Parameters:
    ///   - direction: which way the bubble is dragged. Use `.rightToLeft` for
    ///     the current user's own (trailing) bubbles so the drag pulls away
    ///     from the edge they sit on, and `.leftToRight` for received ones.
    ///   - onTap: called when the bubble is tapped. This lives here rather
    ///     than on the bubble's own contents because the gesture layer added
    ///     by this modifier is the hit-test target across the bubble's frame,
    ///     so a Button inside it would never receive the touch. Pass `nil`
    ///     when the bubble has nothing to do on tap, and taps are ignored.
    public func swipeToReply(
        direction: SwipeReplyDirection = .leftToRight,
        onTap: (() -> Void)? = nil,
        onReply: @escaping () -> Void
    ) -> some View {
        modifier(SwipeToReplyModifier(direction: direction, onTap: onTap, onReply: onReply))
    }
}

// MARK: - Previews

#Preview("Swipe To Reply") {
    ScrollView {
        VStack(spacing: Spacing.lg) {
            ForEach(0..<12, id: \.self) { index in
                let isSent = !index.isMultiple(of: 2)
                ChatBubble(
                    isSent
                        ? "Mine — swipe me left to reply. (\(index))"
                        : "Theirs — swipe me right to reply. (\(index))",
                    style: isSent ? .sent : .received,
                    timestamp: "1:12 PM"
                )
                .swipeToReply(direction: isSent ? .rightToLeft : .leftToRight) {}
            }
        }
        .padding(Spacing.xl)
    }
    .background(Color(hex: 0xF8F9FA))
}

#endif
