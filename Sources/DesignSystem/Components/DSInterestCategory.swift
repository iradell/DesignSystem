import SwiftUI

// MARK: - Interest Category

public struct DSInterestCategory: View {
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
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            HStack(spacing: DSSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(DSColors.textPrimary)

                Text(title.uppercased())
                    .font(DSTypography.labelMedium)
                    .foregroundStyle(DSColors.textPrimary)
                    .tracking(1.2)
            }
            .opacity(0.7)

            DSChipGroup(chips: interests, selectedChips: $selectedInterests)
        }
    }
}

// MARK: - Previews

#Preview("Interest Categories") {
    @Previewable @State var selected: Set<String> = ["Photography", "Hiking", "Astronomy"]

    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            DSInterestCategory(
                icon: "paintpalette",
                title: "Creative Hobbies",
                interests: ["Painting", "Photography", "Writing", "Crafting", "Playing music", "Pottery"],
                selectedInterests: $selected
            )

            DSInterestCategory(
                icon: "figure.run",
                title: "Movement",
                interests: ["Running", "Cycling", "Hiking", "Yoga", "Surfing"],
                selectedInterests: $selected
            )

            DSInterestCategory(
                icon: "brain.head.profile",
                title: "Intellectual",
                interests: ["Reading", "Chess", "Astronomy"],
                selectedInterests: $selected
            )
        }
        .padding(32)
    }
    .background(DSColors.onboardingGradient)
}
