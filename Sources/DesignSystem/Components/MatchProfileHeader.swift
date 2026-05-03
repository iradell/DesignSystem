import SwiftUI

// MARK: - Match Profile Header

public struct MatchProfileHeader: View {
    private let name: String
    private let age: Int
    private let isVerified: Bool
    private let location: String
    private let vibePercentage: Int

    public init(
        name: String,
        age: Int,
        isVerified: Bool = true,
        location: String,
        vibePercentage: Int
    ) {
        self.name = name
        self.age = age
        self.isVerified = isVerified
        self.location = location
        self.vibePercentage = vibePercentage
    }

    public var body: some View {
        HStack(alignment: .top) {
            // Left: name + location
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xs) {
                    Text("\(name), \(age)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Colors.textPrimary)

                    if isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Colors.accentIndigo)
                    }
                }

                Text(location.uppercased())
                    .font(Typography.labelSmall)
                    .foregroundStyle(Colors.textSecondary)
                    .tracking(1)
            }

            Spacer()

            // Right: vibe intel badge
            VStack(spacing: 2) {
                Text("\(vibePercentage)%")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Colors.textOnDark)

                Text("VIBE INTEL ◎")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .tracking(1)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Colors.accentIndigo)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.top, Spacing.md)
    }
}

// MARK: - Previews

#Preview("Match Profile Header") {
    VStack {
        MatchProfileHeader(
            name: "Sophie",
            age: 24,
            location: "3 miles away • London",
            vibePercentage: 98
        )

        MatchProfileHeader(
            name: "Marcus",
            age: 27,
            isVerified: false,
            location: "5 miles away • Manchester",
            vibePercentage: 85
        )
    }
    .background(Color(hex: 0xF8F9FA))
}
