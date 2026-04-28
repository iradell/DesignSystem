import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DSHaptics
//
// Single API for every haptic moment in the app. The agent rule
// "every visual error/success/warning gets a haptic" is enforced by
// routing all such moments through this namespace, so behaviour stays
// consistent (and accessibility-respecting) across scenes.
//
// Implementation notes:
// - One **shared** generator per kind. `UINotificationFeedbackGenerator`
//   and `UIImpactFeedbackGenerator` are intentionally cheap to keep
//   alive, and reusing the instance lets the system pre-warm the
//   Taptic Engine via `prepare()`.
// - `prepare()` is called lazily on first access (and again right
//   before each fire) to keep latency low without warming on app
//   launch.
// - DesignSystem also targets macOS for previews; UIKit is gated so
//   the package still compiles on macOS targets.
// - Methods are `@MainActor` because `UIFeedbackGenerator` requires
//   the main thread.

@MainActor
public enum DSHaptics {

    public enum ImpactStyle: Sendable {
        case light
        case medium
        case heavy
        case soft
        case rigid
    }

    // MARK: - Public API

    /// Negative feedback — pair with a destructive validation moment.
    /// Use this whenever a field flips into an error state, a form
    /// rejects a submission, or anything visually shakes / turns red.
    public static func error() {
        #if canImport(UIKit)
        notify(.error)
        #endif
    }

    /// Positive feedback — pair with a success affordance (a check
    /// mark animation, a confirmed save, etc.).
    public static func success() {
        #if canImport(UIKit)
        notify(.success)
        #endif
    }

    /// Cautionary feedback — pair with a warning callout (something
    /// non-destructive but worth noticing).
    public static func warning() {
        #if canImport(UIKit)
        notify(.warning)
        #endif
    }

    /// Neutral tactile feedback for taps that aren't success/warning/
    /// error — buttons, toggles, drags committing, etc.
    public static func impact(_ style: ImpactStyle = .light) {
        #if canImport(UIKit)
        let generator = impactGenerator(for: style)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }

    /// Pre-warms the Taptic Engine for an upcoming notification haptic.
    /// Call this when you know an `error()` / `success()` / `warning()`
    /// is about to fire (e.g. just before kicking off a network request
    /// whose failure will trigger one). Optional — every public method
    /// already calls `prepare()` immediately before firing.
    public static func prepareNotification() {
        #if canImport(UIKit)
        notificationGenerator.prepare()
        #endif
    }

    // MARK: - Internals

    #if canImport(UIKit)
    private static let notificationGenerator = UINotificationFeedbackGenerator()

    // Cache one impact generator per style — the system spins up a new
    // Taptic engine session per generator instance, so reusing them
    // keeps latency low.
    private static var impactGenerators: [ImpactStyle: UIImpactFeedbackGenerator] = [:]

    private static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }

    private static func impactGenerator(for style: ImpactStyle) -> UIImpactFeedbackGenerator {
        if let existing = impactGenerators[style] {
            return existing
        }
        let generator: UIImpactFeedbackGenerator
        switch style {
        case .light:  generator = UIImpactFeedbackGenerator(style: .light)
        case .medium: generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy:  generator = UIImpactFeedbackGenerator(style: .heavy)
        case .soft:   generator = UIImpactFeedbackGenerator(style: .soft)
        case .rigid:  generator = UIImpactFeedbackGenerator(style: .rigid)
        }
        impactGenerators[style] = generator
        return generator
    }
    #endif
}
