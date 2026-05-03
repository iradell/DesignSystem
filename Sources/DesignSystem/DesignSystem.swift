// DesignSystem - Core UI Components
//
// A glassmorphic design system for SwiftUI built from Figma specs.
//
// TOKENS:
//   Colors         - Color palette (text, backgrounds, accents, glass, gradients, validation)
//   Typography     - Font styles (display, heading, body, label, button, chip, caption)
//   Spacing        - Spacing scale (xxs through xxxxl)
//   Radius         - Corner radius scale (sm through pill)
//
// COMPONENTS:
//   PrimaryButton      - Primary CTA (dark or gradient style)
//   SecondaryButton    - Secondary/text button
//   BackButton         - Circular glass back button
//   SocialButton       - Social auth button (Apple, Google, Facebook, Twitter) with icon-only mode
//   ActionButton       - Small gradient action button (e.g. "Answer Now")
//   GlassTextField     - Glass text input with optional label and secure toggle
//   DOBField           - Single date-of-birth field (Day/Month/Year)
//   DOBInputGroup      - Grouped DOB fields
//   OTPField           - Multi-digit OTP code input
//   PasswordChecklist  - Password validation rules with check/circle icons
//   TextLink           - Uppercase indigo text link button
//   ResendTimer        - Uppercase indigo timer label
//   Chip               - Selectable chip/tag
//   ChipGroup          - Flowing chip layout with multi-select
//   GlassCard          - Generic glass card container
//   SocialProofCard    - Pre-built social proof card
//   QuoteCard          - Pre-built quote/testimonial card
//   HeroPromptCard     - Daily prompt hero card (default + expanded with answer input)
//   MatchCard          - Profile match card with gradient overlay
//   MatchCardGrid      - Profile match card for 2-column grid layout
//   MatchesSection     - Horizontal scrolling matches section
//   InsightRow         - Glass icon + title/subtitle/description row
//   AIIntelCard        - AI Intel Report glass card
//   PromptAnswerCard   - Nested answer card with label and quoted text
//   EmptyState         - Empty/error state with icon, headline, action button
//   MatchProfileHeader - Profile header with name, verified badge, vibe intel %
//   AnswerInput        - Glass text area for prompt answers
//   Tag                - Small accent/badge tag
//   MatchBadge         - Match percentage badge
//   Avatar             - Circular avatar with border
//   AvatarStack        - Overlapping avatar stack with count
//   HomeHeader         - Home screen header with avatar and timer
//   CompactTimer       - Compact countdown pill
//   TabBar             - Bottom floating tab bar
//   StepItem           - How-it-works step row
//   StepList           - Vertical list of step items
//   TextDivider        - Horizontal divider with centered text
//   InterestCategory   - Interest section with icon header and chips
//   GlassIcon          - App logo / dark glass icon
//   IllustrationIcon   - Light glass illustration icon
//   SearchBar          - Glass search bar with magnifying glass icon
//   ChatBubble         - Chat message bubble (sent/received variants)
//   QuotedChatBubble   - Sent bubble with embedded quoted vibe
//   ChatInputBar       - Glass capsule chat input with send button
//   ChatListItem       - Chat list row with avatar, name, preview, unread dot
//   ContextPill        - Small glass pill with sparkle icon + label
//   PopoverMenu        - Glass dropdown menu with action items
//   GradientBackground - Full-screen gradient background
//   FlowLayout           - Wrapping flow layout for chips
//
// MODIFIERS:
//   .background(_:)                     - Apply onboarding or form gradient background
//   .navigationBar(title:onBack:trailing:) - Configure system nav bar with DS chrome
//   .scrollAwareNavigationBackground(…) - Fade header background 0→1 as user scrolls
//   .shake(trigger:amplitude:duration:) - Horizontal shake on validation failure
