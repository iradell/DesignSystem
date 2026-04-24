import SwiftUI

// MARK: - Popover Menu Item

public struct DSPopoverMenuItem: Identifiable {
    public let id: String
    public let title: String
    public let icon: String
    public let role: Role
    public let action: () -> Void

    public enum Role {
        case normal
        case warning
        case destructive
    }

    public init(
        id: String = UUID().uuidString,
        title: String,
        icon: String,
        role: Role = .normal,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.role = role
        self.action = action
    }

    var foregroundColor: Color {
        switch role {
        case .normal: DSColors.textPrimary
        case .warning: Color(hex: 0xF97316)
        case .destructive: Color(hex: 0xEF4444)
        }
    }
}

// MARK: - Popover Menu

public struct DSPopoverMenu: View {
    private let items: [DSPopoverMenuItem]

    public init(items: [DSPopoverMenuItem]) {
        self.items = items
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: item.action) {
                    HStack(spacing: DSSpacing.sm) {
                        Image(systemName: item.icon)
                            .font(.system(size: 16))
                            .foregroundStyle(item.foregroundColor)
                            .frame(width: 18, height: 18)

                        Text(item.title)
                            .font(DSTypography.bodySmall)
                            .foregroundStyle(item.foregroundColor)

                        Spacer()
                    }
                    .padding(.horizontal, DSSpacing.md)
                    .padding(.vertical, DSSpacing.md)
                    .overlay(alignment: .bottom) {
                        if index < items.count - 1 {
                            Rectangle()
                                .fill(Color.black.opacity(0.05))
                                .frame(height: 1)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.xl)
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 50, y: 25)
        .frame(width: 224)
    }
}

// MARK: - Previews

#Preview("Popover Menu") {
    ZStack {
        DSColors.onboardingGradient.ignoresSafeArea()

        DSPopoverMenu(items: [
            DSPopoverMenuItem(title: "View Vibe Profile", icon: "person.crop.circle") {},
            DSPopoverMenuItem(title: "Mute Notifications", icon: "bell.slash") {},
            DSPopoverMenuItem(title: "Clear Vibe History", icon: "trash") {},
            DSPopoverMenuItem(title: "Report User", icon: "exclamationmark.triangle", role: .warning) {},
            DSPopoverMenuItem(title: "Block User", icon: "hand.raised.fill", role: .destructive) {},
        ])
    }
}
