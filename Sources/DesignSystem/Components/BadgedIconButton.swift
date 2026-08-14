import SwiftUI

// MARK: - Badged Icon Button

/// Circular glass icon button with an optional numeric badge pinned to its
/// top-trailing corner — e.g. the "vibe pulse" hub trigger on the chat list,
/// or any future notification-style entry point.
public struct BadgedIconButton: View {
    private let systemImage: String
    private let size: CGFloat
    private let badgeCount: Int?
    private let action: () -> Void

    public init(
        systemImage: String = "sparkles",
        size: CGFloat = 48,
        badgeCount: Int? = nil,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.size = size
        self.badgeCount = badgeCount
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: systemImage)
                    .font(.system(size: size * 0.5, weight: .regular))
                    .foregroundStyle(Colors.textPrimary)
                    .frame(width: size, height: size)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.42, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.42, style: .continuous)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)

                if let badgeCount, badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(Color.white)
                        .frame(width: 24, height: 24)
                        .background(Colors.accentIndigo)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Badged Icon Button") {
    HStack(spacing: Spacing.xl) {
        BadgedIconButton(badgeCount: 3) {}
        BadgedIconButton(systemImage: "bell.fill", badgeCount: 12) {}
        BadgedIconButton {}
    }
    .padding(Spacing.xl)
    .background(Colors.onboardingGradient)
}
