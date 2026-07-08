import SwiftUI

public enum Typography {
    // MARK: - Display / Headlines
    // Google Sans Flex ExtraBold equivalent — geometric sans, system black weight.
    public static let displayLarge = Font.system(size: 36, weight: .black, design: .default)
    public static let displayMedium = Font.system(size: 30, weight: .black, design: .default)
    public static let displaySmall = Font.system(size: 24, weight: .black, design: .default)

    // MARK: - Headings
    public static let headingLarge = Font.system(size: 36, weight: .heavy)
    public static let headingMedium = Font.system(size: 24, weight: .heavy)
    public static let headingSmall = Font.system(size: 20, weight: .heavy)

    // MARK: - Body (Google Sans Flex / Plus Jakarta Sans equivalent)
    public static let bodyLarge = Font.system(size: 18, weight: .regular)
    public static let bodyMedium = Font.system(size: 16, weight: .medium)
    public static let bodyDefault = Font.system(size: 16, weight: .regular)
    public static let bodySmall = Font.system(size: 14, weight: .medium)

    // MARK: - Labels
    public static let labelLarge = Font.system(size: 14, weight: .semibold)
    public static let labelMedium = Font.system(size: 12, weight: .semibold)
    public static let labelSmall = Font.system(size: 10, weight: .heavy)

    // MARK: - Buttons
    /// Primary CTA — Plus Jakarta Sans SemiBold 18pt per spec.
    public static let buttonPrimary = Font.system(size: 18, weight: .semibold)
    public static let buttonSecondary = Font.system(size: 14, weight: .medium)
    public static let buttonSmall = Font.system(size: 14, weight: .semibold)
    public static let buttonAction = Font.system(size: 14, weight: .heavy)

    /// Uppercase action-link label (e.g. "FORGOT PASSWORD?").
    /// Pair with `.tracking(1.2)` on the Text view per Figma spec.
    public static let buttonLink = Font.system(size: 12, weight: .semibold)

    // MARK: - Chips
    public static let chip = Font.system(size: 12, weight: .semibold)

    // MARK: - Caption / Tiny
    public static let caption = Font.system(size: 10, weight: .semibold)
    public static let captionSmall = Font.system(size: 9, weight: .heavy)
    public static let tiny = Font.system(size: 8, weight: .semibold)
}
