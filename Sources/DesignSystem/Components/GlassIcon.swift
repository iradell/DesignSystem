import SwiftUI

// MARK: - Glass Icon (App Logo / Illustration style)

public struct GlassIcon: View {
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
            .background(Colors.bgDark)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.34))
            .shadow(color: .black.opacity(0.1), radius: 15, y: 10)
            .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
    }
}

// MARK: - Glass Illustration Icon (lighter, for verification etc.)

public struct IllustrationIcon: View {
    private let systemName: String
    private let size: CGFloat

    public init(systemName: String, size: CGFloat = 96) {
        self.systemName = systemName
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Colors.accentIndigo.opacity(0.1))
                .frame(width: size + 32, height: size + 32)
                .blur(radius: 32)

            Image(systemName: systemName)
                .font(.system(size: size * 0.375))
                .foregroundStyle(Colors.accentIndigo)
                .frame(width: size, height: size)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Radius.xxl))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.xxl)
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
        GlassIcon(systemName: "sparkles")
        GlassIcon(systemName: "sparkles", size: 48)
        IllustrationIcon(systemName: "sparkles")
        IllustrationIcon(systemName: "calendar", size: 72)
    }
    .padding(32)
    .background(Colors.onboardingGradient)
}
