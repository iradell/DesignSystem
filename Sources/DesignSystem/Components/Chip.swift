import SwiftUI

// MARK: - Chip

public struct Chip: View {
    private let title: String
    private let isSelected: Bool
    private let action: () -> Void

    public init(_ title: String, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.chip)
                .foregroundStyle(isSelected ? Colors.textOnDark : Colors.textPrimary)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(chipBackground)
                .clipShape(Capsule())
                .overlay(chipBorder)
                .shadow(
                    color: isSelected ? Colors.chipGlow : .clear,
                    radius: isSelected ? 15 : 0,
                    y: isSelected ? 10 : 0
                )
                .shadow(
                    color: isSelected ? Colors.chipGlow : .clear,
                    radius: isSelected ? 6 : 0,
                    y: isSelected ? 4 : 0
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            Colors.accentIndigo
        } else {
            Color.white.opacity(0.4)
                .background(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var chipBorder: some View {
        if !isSelected {
            Capsule()
                .stroke(Colors.glassBorderStrong, lineWidth: 1)
        }
    }
}

// MARK: - Chip Flow Layout

public struct ChipGroup: View {
    private let chips: [String]
    @Binding private var selectedChips: Set<String>

    public init(chips: [String], selectedChips: Binding<Set<String>>) {
        self.chips = chips
        self._selectedChips = selectedChips
    }

    public var body: some View {
        FlowLayout(spacing: Spacing.xs) {
            ForEach(chips, id: \.self) { chip in
                Chip(chip, isSelected: selectedChips.contains(chip)) {
                    if selectedChips.contains(chip) {
                        selectedChips.remove(chip)
                    } else {
                        selectedChips.insert(chip)
                    }
                }
            }
        }
    }
}

// MARK: - Flow Layout

public struct FlowLayout: Layout {
    private let spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalWidth = max(totalWidth, currentX - spacing)
        }

        return (
            size: CGSize(width: totalWidth, height: currentY + lineHeight),
            positions: positions
        )
    }
}

// MARK: - Previews

#Preview("Chips") {
    @Previewable @State var selected: Set<String> = ["Photography", "Hiking"]

    VStack(alignment: .leading, spacing: 20) {
        ChipGroup(
            chips: ["Painting", "Photography", "Writing", "Crafting", "Playing music", "Pottery"],
            selectedChips: $selected
        )
    }
    .padding(32)
    .background(Colors.onboardingGradient)
}
