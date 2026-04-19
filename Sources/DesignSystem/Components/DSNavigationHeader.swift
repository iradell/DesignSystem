import SwiftUI

// MARK: - Navigation Header

public struct DSNavigationHeader: View {
    private let onBack: (() -> Void)?
    private let trailingContent: AnyView?
    private let centerContent: AnyView?

    public init(
        onBack: (() -> Void)? = nil
    ) {
        self.onBack = onBack
        self.trailingContent = nil
        self.centerContent = nil
    }

    public init<Trailing: View>(
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.onBack = onBack
        self.trailingContent = AnyView(trailing())
        self.centerContent = nil
    }

    public init<Center: View, Trailing: View>(
        onBack: (() -> Void)? = nil,
        @ViewBuilder center: () -> Center,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.onBack = onBack
        self.centerContent = AnyView(center())
        self.trailingContent = AnyView(trailing())
    }

    public var body: some View {
        HStack {
            if let onBack {
                DSBackButton(action: onBack)
            }

            Spacer()

            if let centerContent {
                centerContent
                Spacer()
            }

            if let trailingContent {
                trailingContent
            }
        }
        .padding(.horizontal, DSSpacing.xxl)
        .padding(.top, DSSpacing.xxxxl)
        .padding(.bottom, DSSpacing.md)
    }
}

// MARK: - Home Header

public struct DSHomeHeader: View {
    private let title: String
    private let avatar: Image?
    private let timerText: String?
    private let onSettingsTap: () -> Void

    public init(
        title: String = "Discover",
        avatar: Image? = nil,
        timerText: String? = nil,
        onSettingsTap: @escaping () -> Void
    ) {
        self.title = title
        self.avatar = avatar
        self.timerText = timerText
        self.onSettingsTap = onSettingsTap
    }

    public var body: some View {
        HStack {
            HStack(spacing: 10) {
                DSAvatar(image: avatar, size: 40)

                Text(title)
                    .font(DSTypography.headingSmall)
                    .foregroundStyle(DSColors.textPrimary)
                    .tracking(-0.5)

                if let timerText {
                    DSCompactTimer(text: timerText)
                }
            }

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
        .background(.ultraThinMaterial)
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

#Preview("Navigation Headers") {
    VStack(spacing: 0) {
        DSNavigationHeader(onBack: {})
            .background(DSColors.onboardingGradient)

        DSNavigationHeader(onBack: {}) {
            Text("SKIP")
                .font(DSTypography.buttonSmall)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(1.4)
        }
        .background(DSColors.onboardingGradient)

        DSNavigationHeader(onBack: {}) {
            Text("STEP 2 OF 3")
                .font(DSTypography.labelSmall)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(2)
        } trailing: {
            EmptyView()
        }
        .background(DSColors.onboardingGradient)
    }
}

#Preview("Home Header") {
    DSHomeHeader(timerText: "01:24:12") {}
        .background(Color(hex: 0xF8F9FA))
}
