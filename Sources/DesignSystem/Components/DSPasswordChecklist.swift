import SwiftUI

// MARK: - Password Checklist

public struct DSPasswordChecklist: View {
    private let rules: [Rule]

    public struct Rule: Identifiable {
        public let id: String
        public let label: String
        public let isMet: Bool

        public init(_ label: String, isMet: Bool) {
            self.id = label
            self.label = label
            self.isMet = isMet
        }
    }

    public init(rules: [Rule]) {
        self.rules = rules
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            ForEach(rules) { rule in
                HStack(spacing: DSSpacing.xs) {
                    Image(systemName: rule.isMet ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 16))
                        .foregroundStyle(rule.isMet ? DSColors.checkGreen : DSColors.textMuted)

                    Text(rule.label)
                        .font(DSTypography.bodyDefault)
                        .fontWeight(rule.isMet ? .semibold : .regular)
                        .foregroundStyle(rule.isMet ? DSColors.textPrimary : DSColors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Password Checklist") {
    DSPasswordChecklist(rules: [
        .init("8+ characters", isMet: true),
        .init("Special character & number", isMet: false),
        .init("Passwords match", isMet: false),
    ])
    .padding(DSSpacing.xl)
    .background(DSColors.onboardingGradient)
}
