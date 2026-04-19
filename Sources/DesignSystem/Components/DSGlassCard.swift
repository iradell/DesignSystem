import SwiftUI

// MARK: - Glass Card Size

public enum DSGlassCardSize {
    case standard
    case large
}

// MARK: - Glass Card

public struct DSGlassCard<Content: View>: View {
    private let size: DSGlassCardSize
    private let content: Content

    public init(
        size: DSGlassCardSize = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.content = content()
    }

    public var body: some View {
        content
            .padding(size == .standard ? DSSpacing.md : DSSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: size == .standard ? DSRadius.md : DSRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: size == .standard ? DSRadius.md : DSRadius.xl)
                    .stroke(DSColors.glassBorderLight, lineWidth: 1)
            )
    }
}

// MARK: - Social Proof Card (pre-built variant)

public struct DSSocialProofCard: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        DSGlassCard(size: .standard) {
            Text(text)
                .font(DSTypography.bodyDefault)
                .foregroundStyle(DSColors.textSecondary)
        }
    }
}

// MARK: - Quote Card (pre-built variant)

public struct DSQuoteCard: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        DSGlassCard(size: .large) {
            Text(text)
                .font(DSTypography.bodyDefault)
                .foregroundStyle(DSColors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Hero Prompt Card

public struct DSHeroPromptCard: View {
    private let tag: String
    private let timeRemaining: String
    private let prompt: String
    private let participantCount: Int
    private let buttonTitle: String
    private let isExpanded: Bool
    @Binding private var answerText: String
    private let action: () -> Void

    public init(
        tag: String = "DAILY PROMPT",
        timeRemaining: String,
        prompt: String,
        participantCount: Int = 0,
        buttonTitle: String = "Answer Now",
        isExpanded: Bool = false,
        answerText: Binding<String> = .constant(""),
        action: @escaping () -> Void
    ) {
        self.tag = tag
        self.timeRemaining = timeRemaining
        self.prompt = prompt
        self.participantCount = participantCount
        self.buttonTitle = buttonTitle
        self.isExpanded = isExpanded
        self._answerText = answerText
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 23) {
            HStack {
                DSTag(tag)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundStyle(DSColors.textSecondary)
                    Text(timeRemaining)
                        .font(DSTypography.bodySmall)
                        .foregroundStyle(DSColors.textSecondary)
                }
            }

            Text(prompt)
                .font(DSTypography.displaySmall.italic())
                .foregroundStyle(DSColors.textPrimary)
                .tracking(-0.6)

            if isExpanded {
                DSAnswerInput(text: $answerText)
            }

            HStack {
                if participantCount > 0 {
                    DSAvatarStack(count: participantCount)
                }
                Spacer()
                DSActionButton(buttonTitle, action: action)
            }
        }
        .padding(29)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xxl))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.xxl)
                .stroke(DSColors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 15, y: 10)
        .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
    }
}

// MARK: - Previews

#Preview("Glass Cards") {
    VStack(spacing: 20) {
        DSSocialProofCard("Card content goes here")

        DSQuoteCard("\"A revolutionary approach to intentional dating and social bonding.\"")

        DSGlassCard(size: .large) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Custom Content")
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.textPrimary)
                Text("You can put anything inside.")
                    .font(DSTypography.bodyDefault)
                    .foregroundStyle(DSColors.textSecondary)
            }
        }
    }
    .padding(32)
    .background(DSColors.onboardingGradient)
}

#Preview("Hero Prompt Card") {
    DSHeroPromptCard(
        timeRemaining: "1h 24m left",
        prompt: "'What is the most underrated movie you've ever seen?'",
        participantCount: 42
    ) {}
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}
