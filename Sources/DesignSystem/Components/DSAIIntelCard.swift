import SwiftUI

// MARK: - AI Intel Card

public struct DSAIIntelCard: View {
    private let body_: String

    public init(_ body: String) {
        self.body_ = body
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            // Header
            HStack(spacing: DSSpacing.xs) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundStyle(DSColors.accentIndigo)

                Text("AI INTEL REPORT")
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.accentIndigo)
                    .tracking(2)
            }

            Text(body_)
                .font(DSTypography.bodyDefault)
                .foregroundStyle(DSColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.lg)
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
    }
}

// MARK: - Previews

#Preview("AI Intel Card") {
    DSAIIntelCard(
        "Our AI connected you because both of you expressed a deep appreciation for introspective sci-fi and quiet, meaningful evenings. Your response to the 'City Life' prompt also aligned perfectly, suggesting a shared value of intentional presence."
    )
    .padding(DSSpacing.xl)
    .background(Color(hex: 0xF8F9FA))
}
