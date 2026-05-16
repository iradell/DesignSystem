import SwiftUI

// MARK: - Match Card Grid

public struct MatchCardGrid: View {
    private let name: String
    private let age: Int
    private let matchPercentage: Int
    private let bio: String
    private let imageSource: ImageSource?

    public init(
        name: String,
        age: Int,
        matchPercentage: Int,
        bio: String,
        image: ImageSource? = nil
    ) {
        self.name = name
        self.age = age
        self.matchPercentage = matchPercentage
        self.bio = bio
        self.imageSource = image
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Image with badge overlay
            ZStack(alignment: .topTrailing) {
                imageContent
                    .frame(maxWidth: .infinity)
                    .frame(height: 185)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                MatchBadge(percentage: matchPercentage)
                    .padding(Spacing.xs)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text("\(name), \(age)")
                    .font(Typography.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.textPrimary)

                Text(bio)
                    .font(Typography.captionSmall)
                    .foregroundStyle(Colors.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(Spacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Colors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 16, y: 4)
    }

    @ViewBuilder
    private var imageContent: some View {
        switch imageSource {
        case .image(let image):
            image
                .resizable()
                .scaledToFill()
        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let loaded):
                    loaded
                        .resizable()
                        .scaledToFill()
                case .empty, .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
        case .none:
            placeholder
        }
    }

    private var placeholder: some View {
        Color(hex: 0xE5E7EB)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.white.opacity(0.5))
            )
    }
}

// MARK: - Previews

#Preview("Match Card Grid") {
    LazyVGrid(columns: [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ], spacing: 16) {
        MatchCardGrid(
            name: "Elena",
            age: 23,
            matchPercentage: 98,
            bio: "Digital artist & morning person"
        )
        MatchCardGrid(
            name: "Julian",
            age: 26,
            matchPercentage: 94,
            bio: "Photography & low-fi beats"
        )
    }
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
