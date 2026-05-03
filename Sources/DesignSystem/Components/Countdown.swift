import SwiftUI

// MARK: - Countdown Style

/// Visual format for a `CountdownText`.
///
/// - `compact`: zero-padded `HH:MM:SS` (e.g. `01:24:12`). Best for a header pill.
/// - `verbose`: human readable, drops empty leading units (e.g. `1h 24m left`,
///   `24m 12s left`, `42s left`). Best for in-content labels next to a clock icon.
public enum CountdownStyle: Sendable {
    case compact
    case verbose
}

// MARK: - Countdown Text

/// A self-ticking countdown label.
///
/// Pass the **same `targetDate`** to every place that needs to display the
/// session timer (e.g. the home header pill and the hero prompt card) — both
/// instances will stay in sync automatically because the source of truth is
/// the wall-clock difference between `Date.now` and `targetDate`.
///
/// The view drives itself via `TimelineView(.periodic(from:by:))`, so callers
/// don't need to manage a `Timer`/`@State` themselves. When the deadline is
/// reached the view renders the format's "0" state (`00:00:00` or `0s left`).
public struct CountdownText: View {
    private let targetDate: Date
    private let style: CountdownStyle

    public init(targetDate: Date, style: CountdownStyle = .compact) {
        self.targetDate = targetDate
        self.style = style
    }

    public var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let remaining = max(0, Int(targetDate.timeIntervalSince(context.date).rounded(.down)))
            Text(Self.format(remaining: TimeInterval(remaining), style: style))
                .monospacedDigit()
                .contentTransition(.numericText(countsDown: true))
                .animation(.smooth(duration: 0.3), value: remaining)
        }
    }

    // MARK: - Formatting

    /// Renders the given number of seconds in the chosen style.
    /// Public so callers (e.g. previews, snapshot tests) can format without a view.
    public static func format(remaining seconds: TimeInterval, style: CountdownStyle) -> String {
        let total = max(0, Int(seconds.rounded(.down)))
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60

        switch style {
        case .compact:
            return String(format: "%02d:%02d:%02d", h, m, s)

        case .verbose:
            if h > 0 { return "\(h)h \(m)m left" }
            if m > 0 { return "\(m)m \(s)s left" }
            return "\(s)s left"
        }
    }
}

// MARK: - Previews

#Preview("Countdown Text") {
    @Previewable @State var target = Date().addingTimeInterval(60 * 60 + 24 * 60 + 12)
    VStack(spacing: 16) {
        CountdownText(targetDate: target, style: .compact)
            .font(Typography.bodySmall)
            .foregroundStyle(Colors.accentIndigo)

        CountdownText(targetDate: target, style: .verbose)
            .font(Typography.bodySmall)
            .foregroundStyle(Colors.textSecondary)
    }
    .padding(24)
    .background(Colors.bgLightAlt)
}
