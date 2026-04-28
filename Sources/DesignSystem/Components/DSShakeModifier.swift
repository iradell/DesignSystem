import SwiftUI

// MARK: - Shake Modifier

/// A `ViewModifier` that performs a short horizontal shake whenever its
/// `trigger` value changes. Designed for validation feedback on input
/// fields — pair with the `isError` flag on `DSDOBField` /
/// `DSGlassTextField` (or any field that exposes one).
///
/// The shake runs ~0.4s at small amplitude (≈8pt), which is the standard
/// "this is wrong" feedback shape used across iOS:
/// 0 → +8 → -7 → +5 → -3 → +1 → 0.
///
/// The view is moved via an `offset` driven by `keyframeAnimator`, so the
/// underlying layout never changes — there's no jank on neighbouring views.
///
/// **Usage:**
/// ```swift
/// // Bump `shakeTrigger` (Int) whenever you want a shake; the value itself
/// // is irrelevant — the modifier only watches for changes.
/// DSDOBInputGroup(day: $d, month: $m, year: $y, isError: hasError)
///     .dsShake(trigger: shakeTrigger)
/// ```
public struct DSShakeModifier: ViewModifier {

    // MARK: Inputs

    /// Any `Equatable` value — when it changes, the shake plays once.
    /// Typical pattern: an `Int` that callers increment on each
    /// validation failure.
    private let trigger: AnyHashable
    private let amplitude: CGFloat
    private let duration: Double

    // MARK: Init

    public init(
        trigger: AnyHashable,
        amplitude: CGFloat = 8,
        duration: Double = 0.4
    ) {
        self.trigger = trigger
        self.amplitude = amplitude
        self.duration = duration
    }

    // MARK: Body

    public func body(content: Content) -> some View {
        content
            .keyframeAnimator(
                initialValue: CGFloat(0),
                trigger: trigger
            ) { view, offsetX in
                view.offset(x: offsetX)
            } keyframes: { _ in
                // Five oscillations decaying toward zero, summing to ~duration.
                // The values are chosen so the motion reads as a "no" shake
                // rather than a wobble — quick first swing, fast settle.
                KeyframeTrack {
                    CubicKeyframe(amplitude,         duration: duration * 0.15)
                    CubicKeyframe(-amplitude * 0.85, duration: duration * 0.20)
                    CubicKeyframe(amplitude  * 0.60, duration: duration * 0.20)
                    CubicKeyframe(-amplitude * 0.35, duration: duration * 0.20)
                    CubicKeyframe(amplitude  * 0.15, duration: duration * 0.15)
                    CubicKeyframe(0,                 duration: duration * 0.10)
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    /// Plays a short horizontal shake animation each time `trigger` changes.
    /// Use to draw the user's attention to a field that just failed
    /// validation. Pair with the field's own `isError` styling so the
    /// motion and the colour change happen together.
    ///
    /// - Parameters:
    ///   - trigger: Any `Hashable` value that mutates on each shake (most
    ///     callers use an `Int` they increment from a side effect).
    ///   - amplitude: Maximum horizontal displacement, in points. Default `8`.
    ///   - duration: Total shake length, in seconds. Default `0.4`.
    public func dsShake<T: Hashable>(
        trigger: T,
        amplitude: CGFloat = 8,
        duration: Double = 0.4
    ) -> some View {
        modifier(
            DSShakeModifier(
                trigger: AnyHashable(trigger),
                amplitude: amplitude,
                duration: duration
            )
        )
    }
}

// MARK: - Preview

#Preview("DS Shake — tap to shake") {
    struct Demo: View {
        @State private var trigger = 0
        var body: some View {
            VStack(spacing: 24) {
                Text("Tap me")
                    .font(DSTypography.bodyLarge)
                    .foregroundStyle(DSColors.textPrimary)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.lg)
                            .stroke(DSColors.destructive, lineWidth: 1)
                    )
                    .dsShake(trigger: trigger)
                    .onTapGesture { trigger += 1 }
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DSColors.onboardingGradient)
        }
    }
    return Demo()
}
