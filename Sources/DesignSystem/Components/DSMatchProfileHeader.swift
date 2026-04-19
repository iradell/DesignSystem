import SwiftUI

// MARK: - Match Profile Header

public struct DSMatchProfileHeader: View {
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
            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                HStack(spacing: DSSpacing.xs) {
                    Text("\(name), \(age)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(DSColors.textPrimary)

                    if isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(DSColors.accentIndigo)
                    }
                }

                Text(location.uppercased())
                    .font(DSTypography.labelSmall)
                    .foregroundStyle(DSColors.textSecondary)
                    .tracking(1)
            }

            Spacer()

            // Right: vibe intel badge
            VStack(spacing: 2) {
                Text("\(vibePercentage)%")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(DSColors.textOnDark)

                Text("VIBE INTEL ◎")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .tracking(1)
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(DSColors.accentIndigo)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, DSSpacing.xl)
        .padding(.top, DSSpacing.md)
    }
}

// MARK: - Previews

#Preview("Match Profile Header") {
    VStack {
        DSMatchProfileHeader(
            name: "Sophie",
            age: 24,
            location: "3 miles away • London",
            vibePercentage: 98
        )

        DSMatchProfileHeader(
            name: "Marcus",
            age: 27,
            isVerified: false,
            location: "5 miles away • Manchester",
            vibePercentage: 85
        )
    }
    .background(Color(hex: 0xF8F9FA))
}
