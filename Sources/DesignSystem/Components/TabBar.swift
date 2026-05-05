import SwiftUI

// MARK: - Tab Item

public struct TabItem: Equatable, Sendable {
    public let id: String
    public let title: String
    public let icon: String

    public init(id: String, title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

// MARK: - Tab Bar

public struct TabBar: View {
    private let items: [TabItem]
    @Binding private var selectedId: String

    @State private var dragLocation: CGFloat? = nil
    @State private var isDragging: Bool = false

    private let barHeight: CGFloat = 80
    private let indicatorHeight: CGFloat = 64
    private let horizontalInset: CGFloat = 8
    private let dragActivationDistance: CGFloat = 6

    public init(items: [TabItem], selectedId: Binding<String>) {
        self.items = items
        self._selectedId = selectedId
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = Layout(
                width: proxy.size.width,
                inset: horizontalInset,
                count: items.count
            )
            let selectedIndex = items.firstIndex(where: { $0.id == selectedId }) ?? 0
            let indicatorCenterX = dragLocation ?? layout.center(of: selectedIndex)
            let highlightedIndex = (dragLocation != nil)
                ? layout.index(forCenter: indicatorCenterX)
                : selectedIndex

            ZStack {
                background
                indicator(width: layout.cellWidth)
                    .position(x: indicatorCenterX, y: barHeight / 2)
                    .allowsHitTesting(false)
                labels(highlightedIndex: highlightedIndex)
            }
            .frame(width: proxy.size.width, height: barHeight)
            .contentShape(Capsule())
            .gesture(dragGesture(layout: layout))
        }
        .frame(height: barHeight)
        .shadow(color: .black.opacity(0.2), radius: 25, y: 12)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    // MARK: - Background

    @ViewBuilder
    private var background: some View {
        if #available(iOS 26, *) {
            Capsule()
                .fill(Color.clear)
                .glassEffect(.regular, in: .capsule)
        } else {
            Capsule()
                .fill(.ultraThickMaterial)
                .overlay(Capsule().stroke(Colors.glassBorder, lineWidth: 1))
        }
    }

    // MARK: - Indicator

    @ViewBuilder
    private func indicator(width: CGFloat) -> some View {
        Group {
            if #available(iOS 26, *) {
                Capsule()
                    .fill(Color.clear)
                    .glassEffect(
                        .regular.tint(Colors.accentIndigo.opacity(0.85)).interactive(),
                        in: .capsule
                    )
                    .overlay(
                        Capsule().stroke(.white.opacity(0.25), lineWidth: 1)
                    )
            } else {
                Capsule()
                    .fill(Colors.accentIndigo.opacity(0.92))
                    .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 1))
            }
        }
        .frame(width: width, height: indicatorHeight)
        .shadow(color: Colors.accentIndigo.opacity(0.35), radius: 14, y: 6)
        .scaleEffect(isDragging ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.78), value: isDragging)
    }

    // MARK: - Labels

    private func labels(highlightedIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
                tabContent(item, highlighted: idx == highlightedIndex)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.horizontal, horizontalInset)
        .frame(height: barHeight)
        .allowsHitTesting(false)
    }

    private func tabContent(_ item: TabItem, highlighted: Bool) -> some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: item.icon)
                .font(.system(size: 20, weight: highlighted ? .semibold : .regular))
                .foregroundStyle(highlighted ? Colors.textOnDark : Colors.textMuted)
                .symbolEffect(.bounce, value: highlighted)

            Text(item.title.uppercased())
                .font(highlighted ? Typography.labelSmall : Typography.tiny)
                .foregroundStyle(highlighted ? Colors.textOnDark : Colors.textMuted)
                .tracking(highlighted ? 1 : 0.8)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: highlighted)
    }

    // MARK: - Gesture

    private func dragGesture(layout: Layout) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let movedFar = abs(value.translation.width) > dragActivationDistance
                guard movedFar else { return }

                if !isDragging {
                    isDragging = true
                    Haptics.impact(.soft)
                }
                let x = layout.clamp(value.location.x)
                dragLocation = x
                let idx = layout.index(forCenter: x)
                if items.indices.contains(idx), items[idx].id != selectedId {
                    Haptics.impact(.light)
                    selectedId = items[idx].id
                }
            }
            .onEnded { value in
                let wasDragging = isDragging
                if wasDragging {
                    let snappedIndex = layout.index(forCenter: layout.clamp(value.location.x))
                    if items.indices.contains(snappedIndex) {
                        selectedId = items[snappedIndex].id
                    }
                    isDragging = false
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        dragLocation = nil
                    }
                } else {
                    let idx = layout.index(forCenter: value.location.x)
                    if items.indices.contains(idx), items[idx].id != selectedId {
                        Haptics.impact(.light)
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                            selectedId = items[idx].id
                        }
                    }
                }
            }
    }

    // MARK: - Layout helper

    private struct Layout {
        let width: CGFloat
        let inset: CGFloat
        let count: Int

        var available: CGFloat { max(0, width - 2 * inset) }
        var cellWidth: CGFloat { count > 0 ? available / CGFloat(count) : 0 }

        func center(of index: Int) -> CGFloat {
            inset + cellWidth * (CGFloat(index) + 0.5)
        }

        func index(forCenter x: CGFloat) -> Int {
            guard cellWidth > 0 else { return 0 }
            let relative = x - inset
            let raw = Int((relative / cellWidth).rounded(.down))
            return min(max(raw, 0), max(0, count - 1))
        }

        func clamp(_ x: CGFloat) -> CGFloat {
            let minX = inset + cellWidth / 2
            let maxX = inset + cellWidth * (CGFloat(count) - 0.5)
            return min(max(x, minX), maxX)
        }
    }
}

// MARK: - Previews

#Preview("Tab Bar") {
    @Previewable @State var selectedTab = "explore"

    VStack {
        Spacer()
        TabBar(
            items: [
                TabItem(id: "explore", title: "Explore", icon: "safari"),
                TabItem(id: "matches", title: "Matches", icon: "heart.fill"),
                TabItem(id: "chat", title: "Chat", icon: "message"),
                TabItem(id: "profile", title: "Profile", icon: "person"),
            ],
            selectedId: $selectedTab
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.onboardingGradient)
}
