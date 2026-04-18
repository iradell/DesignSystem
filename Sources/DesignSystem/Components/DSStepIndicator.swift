import SwiftUI

// MARK: - Step Indicator (Dot Progress)

public struct DSStepIndicator: View {
    private let totalSteps: Int
    private let currentStep: Int

    public init(totalSteps: Int, currentStep: Int) {
        self.totalSteps = totalSteps
        self.currentStep = currentStep
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xxs) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(DSColors.accentIndigo)
                    .frame(
                        width: index == currentStep ? 16 : 4,
                        height: 4
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
    }
}

// MARK: - Step Header (label + indicator)

public struct DSStepHeader: View {
    private let label: String
    private let totalSteps: Int
    private let currentStep: Int

    public init(label: String, totalSteps: Int, currentStep: Int) {
        self.label = label
        self.totalSteps = totalSteps
        self.currentStep = currentStep
    }

    public var body: some View {
        VStack(spacing: DSSpacing.xxs) {
            Text(label.uppercased())
                .font(DSTypography.labelSmall)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(2)

            DSStepIndicator(totalSteps: totalSteps, currentStep: currentStep)
        }
    }
}

// MARK: - Previews

#Preview("Step Indicators") {
    VStack(spacing: 30) {
        DSStepIndicator(totalSteps: 3, currentStep: 0)
        DSStepIndicator(totalSteps: 3, currentStep: 1)
        DSStepIndicator(totalSteps: 3, currentStep: 2)

        DSStepHeader(label: "Verify", totalSteps: 3, currentStep: 2)
        DSStepHeader(label: "Step 2 of 3", totalSteps: 3, currentStep: 1)
    }
    .padding(32)
    .background(DSColors.onboardingGradient)
}
