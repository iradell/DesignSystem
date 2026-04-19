import SwiftUI

// MARK: - Match Card Grid

public struct DSMatchCardGrid: View {
    private let name: String
    private let age: Int
    private let matchPercentage: Int
    private let bio: String
    private let image: Image?

    public init(
        name: String,
        age: Int,
        matchPercentage: Int,
        bio: String,
        image: Image? = nil
    ) {
        self.name = name
        self.age = age
        self.matchPercentage = matchPercentage
        self.bio = bio
        self.image = image
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            // Image with badge overlay
            ZStack(alignment: .topTrailing) {
                imageContent
                    .frame(maxWidth: .infinity)
                    .frame(height: 185)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                DSMatchBadge(percentage: matchPercentage)
                    .padding(DSSpacing.xs)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text("\(name), \(age)")
                    .font(DSTypography.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundStyle(DSColors.textPrimary)

                Text(bio)
                    .font(DSTypography.captionSmall)
                    .foregroundStyle(DSColors.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(DSSpacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.lg)
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 16, y: 4)
    }

    @ViewBuilder
    private var imageContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
        } else {
            Color(hex: 0xE5E7EB)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.white.opacity(0.5))
                )
        }
    }
}

// MARK: - Previews

#Preview("Match Card Grid") {
    LazyVGrid(columns: [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ], spacing: 16) {
        DSMatchCardGrid(
            name: "Elena",
            age: 23,
            matchPercentage: 98,
            bio: "Digital artist & morning person"
        )
        DSMatchCardGrid(
            name: "Julian",
            age: 26,
            matchPercentage: 94,
            bio: "Photography & low-fi beats"
        )
    }
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
