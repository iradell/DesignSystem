import SwiftUI

// MARK: - Insight Row

public struct InsightRow: View {
    private let icon: Image
    private let iconColor: Color
    private let title: String
    private let subtitle: String
    private let description: String

    public init(
        icon: Image = Image(systemName: "person.2.fill"),
        iconColor: Color = Colors.accentIndigo,
        title: String,
        subtitle: String,
        description: String
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.description = description
    }

    public var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Glass icon circle
            icon
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 48)
                .background(Colors.chipGlow.opacity(0.6))
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Colors.glassBorder, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .fontWeight(.bold)
                    .foregroundStyle(Colors.textPrimary)

                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundStyle(Colors.accentIndigo)
                    .tracking(2)

                Text(description)
                    .font(Typography.bodyDefault)
                    .foregroundStyle(Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Spacing.md)
    }
}

// MARK: - Previews

#Preview("Insight Row") {
    VStack(spacing: 0) {
        InsightRow(
            icon: Image(systemName: "person.2.fill"),
            title: "98% Match Potential",
            subtitle: "HIGH SIMILARITY",
            description: "Someone who also mentioned 'Interstellar' is waiting for your perspective on this prompt."
        )

        InsightRow(
            icon: Image(systemName: "arrow.up.right"),
            iconColor: Color(hex: 0xF97316),
            title: "Global Conversation",
            subtitle: "TRENDING NOW",
            description: "5.2k viber-souls have already shared their movie secrets. Join the stream."
        )
    }
    .background(Color(hex: 0xF8F9FA))
}
