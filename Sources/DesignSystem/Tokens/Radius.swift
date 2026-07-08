import SwiftUI

public enum Radius {
    public static let sm: CGFloat = 4
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 28
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 44
    public static let pill: CGFloat = 9999

    /// Primary CTA radius — Figma `Sign In` button is 20pt.
    public static let button: CGFloat = 20
    /// Full-screen container radius (used by Figma frame chrome).
    public static let screen: CGFloat = 24
}
