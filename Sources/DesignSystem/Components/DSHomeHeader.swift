import SwiftUI

// MARK: - Home Header

public struct DSHomeHeader: View {
    private let title: String
    private let avatar: Image?
    private let avatarURL: URL?
    private let timerText: String?
    /// Controls whether the compact timer pill is visible.
    /// Pass `false` (or bind to a `Bool`) when the session timer is already shown
    /// in the page content (e.g. the hero prompt card is visible) so that only one
    /// timer is rendered at a time.
    /// Defaults to `true` so all existing callers keep working without changes.
    private let isTimerVisible: Bool
    private let onSettingsTap: () -> Void

    public init(
        title: String = "Discover",
        avatar: Image? = nil,
        avatarURL: URL? = nil,
        timerText: String? = nil,
        isTimerVisible: Bool = true,
        onSettingsTap: @escaping () -> Void
    ) {
        self.title = title
        self.avatar = avatar
        self.avatarURL = avatarURL
        self.timerText = timerText
        self.isTimerVisible = isTimerVisible
        self.onSettingsTap = onSettingsTap
    }

    public var body: some View {
        HStack {
            HStack(spacing: 10) {
                DSAvatar(image: avatar, imageURL: avatarURL, size: 40)

                Text(title)
                    .font(DSTypography.headingSmall)
                    .foregroundStyle(DSColors.textPrimary)
                    .tracking(-0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                if let timerText, isTimerVisible {
                    DSCompactTimer(text: timerText)
                        .layoutPriority(1)
                        .transition(
                            .opacity.combined(with: .offset(y: -DSSpacing.xs))
                        )
                }
            }
            // Reserve the height the timer pill would occupy so the header doesn't
            // jump in size when the timer fades in/out.
            .frame(minHeight: 28)

            Spacer()

            Button(action: onSettingsTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18))
                    .foregroundStyle(DSColors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(DSColors.glassBorderStrong, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, DSSpacing.xl)
        .padding(.vertical, DSSpacing.md)
        .animation(.smooth(duration: 0.3), value: isTimerVisible)
    }
}

// MARK: - Compact Timer

public struct DSCompactTimer: View {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: 12))
                .foregroundStyle(DSColors.accentIndigo)

            Text(text)
                .font(DSTypography.bodySmall)
                .foregroundStyle(DSColors.accentIndigo)
                .tracking(-0.3)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, DSSpacing.xxs)
        .background(Color(hex: 0xEEF2FF).opacity(0.9))
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(DSColors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

// MARK: - Previews

#Preview("Home Header") {
    VStack(spacing: 0) {
        DSHomeHeader(timerText: "01:24:12") {}
            .background(Color(hex: 0xF8F9FA))

        DSHomeHeader(timerText: "01:24:12", isTimerVisible: false) {}
            .background(Color(hex: 0xF8F9FA))
    }
}
