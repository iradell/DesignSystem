import SwiftUI

// MARK: - Interest Category

public struct InterestCategorySection: View {
    private let icon: String
    private let title: String
    private let interests: [String]
    @Binding private var selectedInterests: Set<String>

    public init(
        icon: String,
        title: String,
        interests: [String],
        selectedInterests: Binding<Set<String>>
    ) {
        self.icon = icon
        self.title = title
        self.interests = interests
        self._selectedInterests = selectedInterests
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Colors.textPrimary)

                Text(title.uppercased())
                    .font(Typography.labelMedium)
                    .foregroundStyle(Colors.textPrimary)
                    .tracking(1.2)
            }
            .opacity(0.7)

            ChipGroup(chips: interests, selectedChips: $selectedInterests)
        }
    }
}

// MARK: - Previews

#Preview("Interest Categories") {
    @Previewable @State var selected: Set<String> = ["Photography", "Hiking", "Astronomy"]

    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            InterestCategorySection(
                icon: "paintpalette",
                title: "Creative Hobbies",
                interests: ["Painting", "Photography", "Writing", "Crafting", "Playing music", "Pottery"],
                selectedInterests: $selected
            )

            InterestCategorySection(
                icon: "figure.run",
                title: "Movement",
                interests: ["Running", "Cycling", "Hiking", "Yoga", "Surfing"],
                selectedInterests: $selected
            )

            InterestCategorySection(
                icon: "brain.head.profile",
                title: "Intellectual",
                interests: ["Reading", "Chess", "Astronomy"],
                selectedInterests: $selected
            )
        }
        .padding(32)
    }
    .background(Colors.onboardingGradient)
}
