import SwiftUI

// MARK: - Glass Icon (App Logo / Illustration style)

public struct DSGlassIcon: View {
    private let systemName: String
    private let size: CGFloat
    private let iconColor: Color

    public init(systemName: String, size: CGFloat = 64, iconColor: Color = .white) {
        self.systemName = systemName
        self.size = size
        self.iconColor = iconColor
    }

    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.47))
            .foregroundStyle(iconColor)
            .frame(width: size, height: size)
            .background(DSColors.bgDark)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.34))
            .shadow(color: .black.opacity(0.1), radius: 15, y: 10)
            .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
    }
}

// MARK: - Glass Illustration Icon (lighter, for verification etc.)

public struct DSIllustrationIcon: View {
    private let systemName: String
    private let size: CGFloat

    public init(systemName: String, size: CGFloat = 96) {
        self.systemName = systemName
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(DSColors.accentIndigo.opacity(0.1))
                .frame(width: size + 32, height: size + 32)
                .blur(radius: 32)

            Image(systemName: systemName)
                .font(.system(size: size * 0.375))
                .foregroundStyle(DSColors.accentIndigo)
                .frame(width: size, height: size)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.xxl))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.xxl)
                        .stroke(Color.white, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 25, y: 20)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 8)
        }
    }
}

// MARK: - Previews

#Preview("Glass Icons") {
    VStack(spacing: 30) {
        DSGlassIcon(systemName: "sparkles")
        DSGlassIcon(systemName: "sparkles", size: 48)
        DSIllustrationIcon(systemName: "sparkles")
        DSIllustrationIcon(systemName: "calendar", size: 72)
    }
    .padding(32)
    .background(DSColors.onboardingGradient)
}
