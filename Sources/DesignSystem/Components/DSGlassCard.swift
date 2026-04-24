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
    /// Label shown on the action button when the card is collapsed.
    private let buttonTitle: String
    /// Label shown on the action button when the card is expanded.
    private let submitTitle: String
    private let isExpanded: Bool
    @Binding private var answerText: String
    private let action: () -> Void

    /// Maximum characters allowed in an answer. Drives the counter shown in expanded state.
    private let maxCharacters: Int = 280

    public init(
        tag: String = "DAILY PROMPT",
        timeRemaining: String,
        prompt: String,
        participantCount: Int = 0,
        buttonTitle: String = "Answer Now",
        submitTitle: String = "Submit Answer",
        isExpanded: Bool = false,
        answerText: Binding<String> = .constant(""),
        action: @escaping () -> Void
    ) {
        self.tag = tag
        self.timeRemaining = timeRemaining
        self.prompt = prompt
        self.participantCount = participantCount
        self.buttonTitle = buttonTitle
        self.submitTitle = submitTitle
        self.isExpanded = isExpanded
        self._answerText = answerText
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            // Row 1: Tag + time remaining
            headerRow

            // Row 2: Prompt text
            Text(prompt)
                .font(DSTypography.displaySmall.italic())
                .foregroundStyle(DSColors.textPrimary)
                .tracking(-0.6)
                .fixedSize(horizontal: false, vertical: true)

            // Row 3 (expanded only): answer input + character counter
            if isExpanded {
                expandedInputSection
                    .transition(
                        .opacity
                            .combined(with: .scale(scale: 0.97, anchor: .top))
                    )
            }

            // Row 4: participants + action button
            footerRow
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
        // Animate the card's height change smoothly when isExpanded toggles.
        .animation(.smooth(duration: 0.35), value: isExpanded)
    }

    // MARK: - Subviews

    private var headerRow: some View {
        HStack {
            DSTag(tag)
            Spacer()
            HStack(spacing: DSSpacing.xxs + 2) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundStyle(DSColors.textSecondary)
                Text(timeRemaining)
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var expandedInputSection: some View {
        VStack(alignment: .trailing, spacing: DSSpacing.xs) {
            DSAnswerInput(text: $answerText)

            // Character counter
            let remaining = maxCharacters - answerText.count
            Text("\(remaining)")
                .font(DSTypography.caption)
                .foregroundStyle(remaining < 20 ? DSColors.warning : DSColors.textMuted)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.smooth(duration: 0.2), value: answerText.count)
        }
    }

    private var footerRow: some View {
        HStack(alignment: .center, spacing: DSSpacing.sm) {
            if participantCount > 0 {
                DSAvatarStack(count: participantCount)
            }
            Spacer()
            DSActionButton(isExpanded ? submitTitle : buttonTitle, action: action)
        }
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

#Preview("Hero Prompt Card — Collapsed") {
    DSHeroPromptCard(
        timeRemaining: "1h 24m left",
        prompt: "'What is the most underrated movie you've ever seen?'",
        participantCount: 42
    ) {}
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Hero Prompt Card — Expanded") {
    @Previewable @State var answer: String = ""
    DSHeroPromptCard(
        timeRemaining: "1h 24m left",
        prompt: "'What is the most underrated movie you've ever seen?'",
        participantCount: 42,
        isExpanded: true,
        answerText: $answer
    ) {}
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Hero Prompt Card — Interactive") {
    @Previewable @State var expanded: Bool = false
    @Previewable @State var answer: String = ""
    DSHeroPromptCard(
        timeRemaining: "1h 24m left",
        prompt: "'What is the most underrated movie you've ever seen?'",
        participantCount: 42,
        isExpanded: expanded,
        answerText: $answer
    ) {
        withAnimation(.smooth(duration: 0.35)) {
            expanded.toggle()
        }
    }
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}
