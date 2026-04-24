import SwiftUI

public enum DSColors {
    // MARK: - Text
    public static let textPrimary = Color(hex: 0x121212)
    public static let textSecondary = Color(hex: 0x6B7280)
    public static let textPlaceholder = Color(hex: 0xD1D5DB)
    public static let textOnDark = Color.white
    public static let textMuted = Color(hex: 0x9CA3AF)

    // MARK: - Backgrounds
    public static let bgDark = Color(hex: 0x1C1C1E)
    public static let bgLight = Color(hex: 0xF2F2F7)
    public static let bgLightAlt = Color(hex: 0xF8F9FA)

    // MARK: - Accent
    public static let accentIndigo = Color(hex: 0x6366F1)
    public static let accentPurple = Color(hex: 0x7C3AED)
    public static let accentDeepIndigo = Color(hex: 0x4F46E5)

    // MARK: - Glass
    public static let glassBg = Color.white.opacity(0.4)
    public static let glassBgStrong = Color.white.opacity(0.6)
    public static let glassBorder = Color.white.opacity(0.5)
    public static let glassBorderStrong = Color.white.opacity(0.8)
    public static let glassBorderLight = Color.white.opacity(0.3)

    // MARK: - Gradients
    public static let onboardingGradient = LinearGradient(
        colors: [Color(hex: 0xF2F2F7), Color(hex: 0xE5E7FF)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let primaryButtonGradient = LinearGradient(
        colors: [Color(hex: 0x6366F1), Color(hex: 0x7C3AED)],
        startPoint: .leading,
        endPoint: .trailing
    )

    public static let answerButtonGradient = LinearGradient(
        colors: [Color(hex: 0x6366F1), Color(hex: 0x4F46E5)],
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Validation
    public static let checkGreen = Color(hex: 0x059669)
    public static let checkGreenBg = Color(hex: 0xD1FAE5)
    public static let checkGray = Color(hex: 0xF3F4F6)

    // MARK: - Destructive
    public static let warning = Color(hex: 0xF97316)
    public static let destructive = Color(hex: 0xEF4444)
    public static let onlineGreen = Color(hex: 0x22C55E)

    // MARK: - Misc
    public static let divider = Color(hex: 0xE5E7EB).opacity(0.5)
    public static let badgeBg = Color(hex: 0x6366F1).opacity(0.9)
    public static let tagBg = Color.white.opacity(0.6)
    public static let chipGlow = Color(hex: 0xE0E7FF)
    public static let indigoGlow = Color(hex: 0xE0E7FF)
}

// MARK: - Color Hex Initializer

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
