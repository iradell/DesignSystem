import SwiftUI

public enum Typography {
    // MARK: - Display / Headlines (Playfair Display equivalent)
    public static let displayLarge = Font.system(size: 36, weight: .black, design: .serif)
    public static let displayMedium = Font.system(size: 30, weight: .black, design: .serif)
    public static let displaySmall = Font.system(size: 24, weight: .black, design: .serif)

    // MARK: - Headings (Nimbus Sans / System equivalent)
    public static let headingLarge = Font.system(size: 36, weight: .bold)
    public static let headingMedium = Font.system(size: 24, weight: .heavy)
    public static let headingSmall = Font.system(size: 20, weight: .heavy)

    // MARK: - Body (Plus Jakarta Sans equivalent)
    public static let bodyLarge = Font.system(size: 18, weight: .regular)
    public static let bodyMedium = Font.system(size: 16, weight: .medium)
    public static let bodyDefault = Font.system(size: 14, weight: .medium)
    public static let bodySmall = Font.system(size: 12, weight: .bold)

    // MARK: - Labels
    public static let labelLarge = Font.system(size: 14, weight: .bold)
    public static let labelMedium = Font.system(size: 12, weight: .heavy)
    public static let labelSmall = Font.system(size: 10, weight: .heavy)

    // MARK: - Buttons
    public static let buttonPrimary = Font.system(size: 18, weight: .heavy)
    public static let buttonSecondary = Font.system(size: 14, weight: .regular)
    public static let buttonSmall = Font.system(size: 14, weight: .bold)
    public static let buttonAction = Font.system(size: 14, weight: .heavy)

    // MARK: - Chips
    public static let chip = Font.system(size: 12, weight: .bold)

    // MARK: - Caption / Tiny
    public static let caption = Font.system(size: 10, weight: .bold)
    public static let captionSmall = Font.system(size: 9, weight: .heavy)
    public static let tiny = Font.system(size: 8, weight: .bold)
}
