import SwiftUI

public enum Colors {
    // MARK: - Text
    public static let textPrimary = Color(hex: 0x121212)
    public static let textSecondary = Color(hex: 0x83868C)
    public static let textPlaceholder = Color(hex: 0xB8BABD)
    public static let textOnDark = Color.white
    public static let textMuted = Color(hex: 0x9CA3AF)

    // MARK: - Backgrounds
    /// New default surface: clean white with subtle ambient glow handled by
    /// `GradientBackground`. Use `bgPrimary` when you need a flat surface.
    public static let bgPrimary = Color.white
    public static let bgDark = Color(hex: 0x1C1C1E)
    public static let bgLight = Color.white
    public static let bgLightAlt = Color(hex: 0xF7F7F7)

    /// Ambient radial-glow tints used by `GradientBackground` for the
    /// soft pastel splash behind heading content.
    public static let bgGlowIndigo = Color(hex: 0xC7D0FF)
    public static let bgGlowViolet = Color(hex: 0xD4CCFE)
    public static let bgGlowLavender = Color(hex: 0xE0DAFF)

    // MARK: - Accent
    public static let accentIndigo = Color(hex: 0x6366F1)
    public static let accentPurple = Color(hex: 0x7C3AED)
    public static let accentDeepIndigo = Color(hex: 0x4F46E5)

    // MARK: - Liquid Glass (composable layered effect)
    /// Base white wash that sits over the material — 65% opacity per Figma
    /// `Liquid Glass` token set.
    public static let glassFrostBase = Color.white.opacity(0.65)
    /// Color-burn layer — darkens highlights into a warm grey.
    public static let glassFrostBurn = Color(hex: 0xDDDDDD)
    /// Darken layer — pulls mid-tones into a soft warm cream.
    public static let glassFrostDarken = Color(hex: 0xF7F7F7)
    /// Standard liquid-glass drop shadow (`0 8 40 rgba(0,0,0,0.12)`).
    public static let glassShadow = Color.black.opacity(0.12)
    public static let glassShadowSoft = Color.black.opacity(0.10)

    // Legacy glass tokens — retained so existing components still compile.
    public static let glassBg = Color.white.opacity(0.4)
    public static let glassBgStrong = Color.white.opacity(0.65)
    public static let glassBorder = Color.white.opacity(0.5)
    public static let glassBorderStrong = Color.white.opacity(0.8)
    public static let glassBorderLight = Color.white.opacity(0.3)

    // MARK: - Inputs (soft-grey flat fill per LoginProposedV3)
    /// `rgba(108,112,117, 0.06)` — barely-there grey wash that reads on
    /// white but stays invisible on the lavender ambient glow.
    public static let inputFill = Color(hex: 0x6C7075).opacity(0.06)
    public static let inputBorder = Color.clear
    public static let inputPlaceholder = Color(hex: 0xB8BABD)

    // MARK: - Gradients (kept as tokens for legacy callers; values updated)
    /// The new "background" is solid white with radial glows handled by
    /// `GradientBackground`. This gradient token is preserved for any
    /// caller still using it directly, but resolves to plain white.
    public static let onboardingGradient = LinearGradient(
        colors: [Color.white, Color.white],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Primary CTA is now a solid indigo per spec. Gradient endpoints
    /// collapsed to the same color for compatibility with components that
    /// still call `.fill(Colors.primaryButtonGradient)`.
    public static let primaryButtonGradient = LinearGradient(
        colors: [Color(hex: 0x6366F1), Color(hex: 0x6366F1)],
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
    public static let chipGlow = Color(hex: 0xC7D0FF)
    public static let indigoGlow = Color(hex: 0xC7D0FF)

    // MARK: - Component Surfaces
    public static let surfaceSolidWhiteFill   = Color.white.opacity(0.85)
    public static let surfaceSolidWhiteStroke = Color.black.opacity(0.04)
    public static let surfaceGlassRefinedStroke = accentIndigo.opacity(0.12)
    public static let surfaceTintedIndigoWash   = accentIndigo.opacity(0.08)
    public static let surfaceTintedIndigoStroke = accentIndigo.opacity(0.20)
    public static let surfaceCreamFill   = Color(hex: 0xFFFBF7)
    public static let surfaceCreamStroke = Color(hex: 0xF0EEE8)
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
