// DesignSystem - Core UI Components
//
// A glassmorphic design system for SwiftUI built from Figma specs.
//
// TOKENS:
//   DSColors         - Color palette (text, backgrounds, accents, glass, gradients, validation)
//   DSTypography     - Font styles (display, heading, body, label, button, chip, caption)
//   DSSpacing        - Spacing scale (xxs through xxxxl)
//   DSRadius         - Corner radius scale (sm through pill)
//
// COMPONENTS:
//   DSPrimaryButton      - Primary CTA (dark or gradient style)
//   DSSecondaryButton    - Secondary/text button
//   DSBackButton         - Circular glass back button
//   DSSocialButton       - Social auth button (Apple, Google, Facebook, Twitter) with icon-only mode
//   DSActionButton       - Small gradient action button (e.g. "Answer Now")
//   DSGlassTextField     - Glass text input with optional label and secure toggle
//   DSDOBField           - Single date-of-birth field (Day/Month/Year)
//   DSDOBInputGroup      - Grouped DOB fields
//   DSOTPField           - Multi-digit OTP code input
//   DSPasswordChecklist  - Password validation rules with check/circle icons
//   DSTextLink           - Uppercase indigo text link button
//   DSResendTimer        - Uppercase indigo timer label
//   DSChip               - Selectable chip/tag
//   DSChipGroup          - Flowing chip layout with multi-select
//   DSGlassCard          - Generic glass card container
//   DSSocialProofCard    - Pre-built social proof card
//   DSQuoteCard          - Pre-built quote/testimonial card
//   DSHeroPromptCard     - Daily prompt hero card (default + expanded with answer input)
//   DSMatchCard          - Profile match card with gradient overlay
//   DSMatchCardGrid      - Profile match card for 2-column grid layout
//   DSMatchesSection     - Horizontal scrolling matches section
//   DSInsightRow         - Glass icon + title/subtitle/description row
//   DSAIIntelCard        - AI Intel Report glass card
//   DSPromptAnswerCard   - Nested answer card with label and quoted text
//   DSEmptyState         - Empty/error state with icon, headline, action button
//   DSMatchProfileHeader - Profile header with name, verified badge, vibe intel %
//   DSAnswerInput        - Glass text area for prompt answers
//   DSTag                - Small accent/badge tag
//   DSMatchBadge         - Match percentage badge
//   DSAvatar             - Circular avatar with border
//   DSAvatarStack        - Overlapping avatar stack with count
//   DSHomeHeader         - Home screen header with avatar and timer
//   DSCompactTimer       - Compact countdown pill
//   DSTabBar             - Bottom floating tab bar
//   DSStepItem           - How-it-works step row
//   DSStepList           - Vertical list of step items
//   DSTextDivider        - Horizontal divider with centered text
//   DSInterestCategory   - Interest section with icon header and chips
//   DSGlassIcon          - App logo / dark glass icon
//   DSIllustrationIcon   - Light glass illustration icon
//   DSGradientBackground - Full-screen gradient background
//   FlowLayout           - Wrapping flow layout for chips
//
// MODIFIERS:
//   .dsBackground(_:)                     - Apply onboarding or form gradient background
//   .dsNavigationBar(title:onBack:trailing:) - Configure system nav bar with DS chrome
//   .dsScrollAwareNavigationBackground(…) - Fade header background 0→1 as user scrolls
