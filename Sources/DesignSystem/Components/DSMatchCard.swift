import SwiftUI

// MARK: - Match Card

public struct DSMatchCard: View {
    private let name: String
    private let age: Int
    private let matchPercentage: Int
    private let subtitle: String
    private let image: Image?

    public init(
        name: String,
        age: Int,
        matchPercentage: Int,
        subtitle: String,
        image: Image? = nil
    ) {
        self.name = name
        self.age = age
        self.matchPercentage = matchPercentage
        self.subtitle = subtitle
        self.image = image
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

                HStack(spacing: DSSpacing.xs) {
                    Text("\(name), \(age)")
                        .font(DSTypography.headingSmall)
                        .foregroundStyle(DSColors.textOnDark)

                    DSMatchBadge(percentage: matchPercentage)
                }

                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            .padding(DSSpacing.xl)
        }
        .frame(width: 256, height: 340)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .shadow(color: DSColors.indigoGlow.opacity(0.3), radius: 25, y: 12)
    }

    @ViewBuilder
    private var backgroundContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 256, height: 340)
        } else {
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
}

// MARK: - Matches Scroll

public struct DSMatchesSection: View {
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
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            HStack {
                Text(title)
                    .font(DSTypography.headingMedium)
                    .foregroundStyle(DSColors.textPrimary)
                    .tracking(-0.6)

                Spacer()

                Button(action: onSeeAll) {
                    Text("SEE ALL")
                        .font(DSTypography.labelMedium)
                        .foregroundStyle(DSColors.accentIndigo)
                        .tracking(1.2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, DSSpacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.md) {
                    content
                }
            }
            .contentMargins(.horizontal, DSSpacing.xl, for: .scrollContent)
        }
    }
}

// MARK: - Previews

#Preview("Match Card") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            DSMatchCard(
                name: "Sophie",
                age: 24,
                matchPercentage: 98,
                subtitle: "Loves sci-fi and espresso martinis"
            )

            DSMatchCard(
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
    DSMatchesSection(title: "Top Matches", onSeeAll: {}) {
        DSMatchCard(name: "Sophie", age: 24, matchPercentage: 98, subtitle: "Loves sci-fi")
        DSMatchCard(name: "Marcus", age: 27, matchPercentage: 92, subtitle: "Architecture")
    }
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}
