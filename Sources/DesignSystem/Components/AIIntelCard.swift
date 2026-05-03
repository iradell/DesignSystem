import SwiftUI

// MARK: - AI Intel Card

public struct AIIntelCard: View {
    private let body_: String

    public init(_ body: String) {
        self.body_ = body
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Header
            HStack(spacing: Spacing.xs) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundStyle(Colors.accentIndigo)

                Text("AI INTEL REPORT")
                    .font(Typography.caption)
                    .foregroundStyle(Colors.accentIndigo)
                    .tracking(2)
            }

            Text(body_)
                .font(Typography.bodyDefault)
                .foregroundStyle(Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Colors.glassBorder, lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("AI Intel Card") {
    AIIntelCard(
        "Our AI connected you because both of you expressed a deep appreciation for introspective sci-fi and quiet, meaningful evenings. Your response to the 'City Life' prompt also aligned perfectly, suggesting a shared value of intentional presence."
    )
    .padding(Spacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
