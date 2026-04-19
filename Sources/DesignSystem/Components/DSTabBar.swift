import SwiftUI

// MARK: - Tab Item

public struct DSTabItem: Equatable, Sendable {
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

public struct DSTabBar: View {
    private let items: [DSTabItem]
    @Binding private var selectedId: String
    @Namespace private var tabNamespace

    public init(items: [DSTabItem], selectedId: Binding<String>) {
        self.items = items
        self._selectedId = selectedId
    }

    public var body: some View {
        if #available(iOS 26, *) {
            glassTabBar
        } else {
            materialTabBar
        }
    }

    // MARK: - iOS 26+ Glass Tab Bar

    @available(iOS 26, *)
    private var glassTabBar: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(items, id: \.id) { item in
                    tabButton(for: item)
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 1)
            .frame(height: 80)
            .glassEffect(.regular, in: .capsule)
        }
        .shadow(color: .black.opacity(0.2), radius: 25, y: 12)
    }

    // MARK: - Fallback Material Tab Bar

    private var materialTabBar: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                tabButton(for: item)
            }
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 1)
        .frame(height: 80)
        .background(.ultraThickMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 25, y: 12)
    }

    // MARK: - Tab Button

    private func tabButton(for item: DSTabItem) -> some View {
        let isSelected = selectedId == item.id

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedId = item.id
            }
        } label: {
            if isSelected {
                selectedTab(item)
            } else {
                unselectedTab(item)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Selected Tab

    private func selectedTab(_ item: DSTabItem) -> some View {
        HStack(spacing: DSSpacing.xs) {
            Image(systemName: item.icon)
                .font(.system(size: 20))
                .foregroundStyle(DSColors.textOnDark)
                .symbolEffect(.bounce, value: selectedId)

            Text(item.title.uppercased())
                .font(DSTypography.labelSmall)
                .foregroundStyle(DSColors.textOnDark)
                .tracking(1)
        }
        .padding(.horizontal, DSSpacing.xl)
        .frame(height: 58)
        .background {
            Capsule()
                .fill(DSColors.accentIndigo)
                .matchedGeometryEffect(id: "activeTab", in: tabNamespace)
        }
        .shadow(color: DSColors.accentIndigo.opacity(0.3), radius: 12, y: 4)
        .transition(.scale(scale: 0.9).combined(with: .opacity))
    }

    // MARK: - Unselected Tab

    private func unselectedTab(_ item: DSTabItem) -> some View {
        VStack(spacing: DSSpacing.xxs) {
            Image(systemName: item.icon)
                .font(.system(size: 20))
                .foregroundStyle(DSColors.textMuted)

            Text(item.title.uppercased())
                .font(DSTypography.tiny)
                .foregroundStyle(DSColors.textMuted)
                .tracking(0.8)
        }
        .frame(width: 64, height: 40)
        .scaleEffect(selectedId == item.id ? 0.85 : 1.0)
    }
}

// MARK: - Previews

#Preview("Tab Bar") {
    @Previewable @State var selectedTab = "explore"

    VStack {
        Spacer()
        DSTabBar(
            items: [
                DSTabItem(id: "explore", title: "Explore", icon: "safari"),
                DSTabItem(id: "matches", title: "Matches", icon: "heart.fill"),
                DSTabItem(id: "chat", title: "Chat", icon: "message"),
                DSTabItem(id: "profile", title: "Profile", icon: "person"),
            ],
            selectedId: $selectedTab
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DSColors.onboardingGradient)
}
