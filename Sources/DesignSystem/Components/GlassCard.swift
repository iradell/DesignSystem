import SwiftUI

// MARK: - Glass Card Size

public enum GlassCardSize {
    case standard
    case large
}

// MARK: - Glass Card

public struct GlassCard<Content: View>: View {
    private let size: GlassCardSize
    private let content: Content

    public init(
        size: GlassCardSize = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.content = content()
    }

    public var body: some View {
        content
            .padding(size == .standard ? Spacing.md : Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: size == .standard ? Radius.md : Radius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: size == .standard ? Radius.md : Radius.xl)
                    .stroke(Colors.glassBorderLight, lineWidth: 1)
            )
    }
}

// MARK: - Social Proof Card (pre-built variant)

public struct SocialProofCard: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        GlassCard(size: .standard) {
            Text(text)
                .font(Typography.bodyDefault)
                .foregroundStyle(Colors.textSecondary)
        }
    }
}

// MARK: - Quote Card (pre-built variant)

public struct QuoteCard: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        GlassCard(size: .large) {
            Text(text)
                .font(Typography.bodyDefault)
                .foregroundStyle(Colors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Hero Prompt Card

public struct HeroPromptCard: View {
    private enum TimerSource {
        case text(String)
        case targetDate(Date)
    }

    private let tag: String
    private let timer: TimerSource
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
        self.timer = .text(timeRemaining)
        self.prompt = prompt
        self.participantCount = participantCount
        self.buttonTitle = buttonTitle
        self.submitTitle = submitTitle
        self.isExpanded = isExpanded
        self._answerText = answerText
        self.action = action
    }

    /// Self-ticking variant — pass the same deadline `Date` as the header timer
    /// so both displays stay in sync. The card formats it as `1h 24m left`.
    public init(
        tag: String = "DAILY PROMPT",
        targetDate: Date,
        prompt: String,
        participantCount: Int = 0,
        buttonTitle: String = "Answer Now",
        submitTitle: String = "Submit Answer",
        isExpanded: Bool = false,
        answerText: Binding<String> = .constant(""),
        action: @escaping () -> Void
    ) {
        self.tag = tag
        self.timer = .targetDate(targetDate)
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
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Row 1: Tag + time remaining
            headerRow

            // Row 2: Prompt text
            Text(prompt)
                .font(Typography.displaySmall.italic())
                .foregroundStyle(Colors.textPrimary)
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
        .clipShape(RoundedRectangle(cornerRadius: Radius.xxl))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.xxl)
                .stroke(Colors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 15, y: 10)
        .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
        // Animate the card's height change smoothly when isExpanded toggles.
        .animation(.smooth(duration: 0.35), value: isExpanded)
    }

    // MARK: - Subviews

    private var headerRow: some View {
        HStack {
            Tag(tag)
            Spacer()
            HStack(spacing: Spacing.xxs + 2) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundStyle(Colors.textSecondary)
                Group {
                    switch timer {
                    case .text(let value):
                        Text(value)
                    case .targetDate(let date):
                        CountdownText(targetDate: date, style: .verbose)
                    }
                }
                .font(Typography.bodySmall)
                .foregroundStyle(Colors.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var expandedInputSection: some View {
        VStack(alignment: .trailing, spacing: Spacing.xs) {
            AnswerInput(text: $answerText)

            // Character counter
            let remaining = maxCharacters - answerText.count
            Text("\(remaining)")
                .font(Typography.caption)
                .foregroundStyle(remaining < 20 ? Colors.warning : Colors.textMuted)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.smooth(duration: 0.2), value: answerText.count)
        }
    }

    private var footerRow: some View {
        HStack(alignment: .center, spacing: Spacing.sm) {
            if participantCount > 0 {
                AvatarStack(count: participantCount)
            }
            Spacer()
            ActionButton(isExpanded ? submitTitle : buttonTitle, action: action)
        }
    }
}

// MARK: - Previews

#Preview("Glass Cards") {
    VStack(spacing: 20) {
        SocialProofCard("Card content goes here")

        QuoteCard("\"A revolutionary approach to intentional dating and social bonding.\"")

        GlassCard(size: .large) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Custom Content")
                    .font(Typography.bodySmall)
                    .foregroundStyle(Colors.textPrimary)
                Text("You can put anything inside.")
                    .font(Typography.bodyDefault)
                    .foregroundStyle(Colors.textSecondary)
            }
        }
    }
    .padding(32)
    .background(Colors.onboardingGradient)
}

#Preview("Hero Prompt Card — Collapsed") {
    HeroPromptCard(
        timeRemaining: "1h 24m left",
        prompt: "'What is the most underrated movie you've ever seen?'",
        participantCount: 42
    ) {}
    .padding(24)
    .background(Color(hex: 0xF8F9FA))
}

#Preview("Hero Prompt Card — Expanded") {
    @Previewable @State var answer: String = ""
    HeroPromptCard(
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
    HeroPromptCard(
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
