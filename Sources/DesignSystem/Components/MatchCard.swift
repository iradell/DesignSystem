import SwiftUI

// MARK: - Match Card

public struct MatchCard: View {
    private let name: String
    private let age: Int
    private let matchPercentage: Int
    private let subtitle: String
    private let image: Image?
    private let imageURL: URL?

    public init(
        name: String,
        age: Int,
        matchPercentage: Int,
        subtitle: String,
        image: Image? = nil,
        imageURL: URL? = nil
    ) {
        self.name = name
        self.age = age
        self.matchPercentage = matchPercentage
        self.subtitle = subtitle
        self.image = image
        self.imageURL = imageURL
    }

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image or placeholder
            backgroundContent

            // Bottom gradient overlay
            LinearGradient(
                colors: [.black.opacity(0.8), .clear],
                startPoint: .bottom,
                endPoint: .center
            )

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Spacer()

                HStack(spacing: Spacing.xs) {
                    Text("\(name), \(age)")
                        .font(Typography.headingSmall)
                        .foregroundStyle(Colors.textOnDark)

                    MatchBadge(percentage: matchPercentage)
                }

                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            .padding(Spacing.xl)
        }
        .frame(width: 256, height: 340)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .shadow(color: Colors.indigoGlow.opacity(0.3), radius: 25, y: 12)
    }

    @ViewBuilder
    private var backgroundContent: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFill()
                        .frame(width: 256, height: 340)
                default:
                    placeholderContent
                }
            }
        } else if let image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 256, height: 340)
        } else {
            placeholderContent
        }
    }

    @ViewBuilder
    private var placeholderContent: some View {
        LinearGradient(
            colors: [Color(hex: 0x6366F1).opacity(0.3), Color(hex: 0x7C3AED).opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            Image(systemName: "person.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.white.opacity(0.3))
        )
    }
}

// MARK: - Matches Scroll

public struct MatchesSection: View {
    private let title: String
    private let onSeeAll: () -> Void
    private let content: AnyView

    public init<Content: View>(
        title: String = "Top Matches",
        onSeeAll: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.onSeeAll = onSeeAll
        self.content = AnyView(content())
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            HStack {
                Text(title)
                    .font(Typography.headingMedium)
                    .foregroundStyle(Colors.textPrimary)
                    .tracking(-0.6)

                Spacer()

                Button(action: onSeeAll) {
                    Text("SEE ALL")
                        .font(Typography.labelMedium)
                        .foregroundStyle(Colors.accentIndigo)
                        .tracking(1.2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.md) {
                    content
                }
            }
            .contentMargins(.horizontal, Spacing.xl, for: .scrollContent)
        }
    }
}

// MARK: - Previews

#Preview("Match Card") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            MatchCard(
                name: "Sophie",
                age: 24,
                matchPercentage: 98,
                subtitle: "Loves sci-fi and espresso martinis"
            )

            MatchCard(
                name: "Marcus",
                age: 27,
                matchPercentage: 92,
                subtitle: "Architecture and long night walks"
            )
        }
        .padding(.horizontal, 24)
    }
    .padding(.vertical, 20)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Matches Section") {
    MatchesSection(title: "Top Matches", onSeeAll: {}) {
        MatchCard(name: "Sophie", age: 24, matchPercentage: 98, subtitle: "Loves sci-fi")
        MatchCard(name: "Marcus", age: 27, matchPercentage: 92, subtitle: "Architecture")
    }
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}
