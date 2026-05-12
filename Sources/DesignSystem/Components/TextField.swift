import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Zero-width space — invisible Unicode character used as a sentinel
/// inside `DOBField` so we can detect a "backspace pressed while
/// the visible text was already empty" event from the iOS soft
/// keyboard.
///
/// SwiftUI's `TextField` doesn't fire `onChange` when the binding's
/// value would stay the empty string (empty → backspace → still empty
/// produces no diff). And `.onKeyPress(.delete)` only fires for
/// hardware keyboards on iOS — the soft keyboard's backspace isn't
/// routed through key-press events.
///
/// The workaround: keep this invisible character in the underlying
/// `@State` text any time the field would otherwise be empty. When
/// the user hits backspace on a visually-empty field they actually
/// delete the sentinel, the binding goes from `"\u{200B}"` → `""`,
/// `onChange` fires, and we know to call `onEmptyBackspace`. We then
/// re-insert the sentinel so the next backspace can be caught too.
///
/// The parent's `Binding<String>` never sees this character — we
/// strip it before writing back, and add it back when reading in.
private let dobSentinel = "\u{200B}"

// MARK: - Glass TextField

public struct GlassTextField: View {
    private let label: String?
    private let placeholder: String
    private let isSecure: Bool
    @Binding private var text: String
    @State private var isSecureVisible = false
    @FocusState private var isFocused: Bool

    public init(
        _ placeholder: String,
        text: Binding<String>,
        label: String? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.label = label
        self.isSecure = isSecure
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            if let label {
                Text(label.uppercased())
                    .font(Typography.labelSmall)
                    .foregroundStyle(Colors.textPrimary)
                    .tracking(10)
            }

            HStack {
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField("", text: $text, prompt: promptText)
                    } else {
                        TextField("", text: $text, prompt: promptText)
                    }
                }
                .font(Typography.bodyMedium.weight(.bold))
                .foregroundStyle(Colors.textPrimary)
                .focused($isFocused)

                if isSecure {
                    Button {
                        isSecureVisible.toggle()
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.fill" : "eye.slash.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Colors.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 21)
            // Layered fill: ultraThinMaterial alone almost vanishes on the
            // unified `.form` background, so we sit a soft white wash on top
            // of it. The border is a low-opacity dark stroke so the field's
            // edge still reads against the lavender gradient.
            .background(.ultraThinMaterial)
            .background(Colors.inputFill)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Colors.inputBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            .contentShape(RoundedRectangle(cornerRadius: Radius.lg))
            .onTapGesture {
                isFocused = true
            }
        }
        .markAsKeyboardInputRegion()
    }

    private var promptText: Text {
        Text(placeholder)
            .font(Typography.bodyMedium.weight(.bold))
            .foregroundStyle(Colors.textMuted)
    }
}

// MARK: - DOB TextField

public struct DOBField: View {
    public enum Field: String, Sendable, Hashable {
        case day = "DAY"
        case month = "MONTH"
        case year = "YEAR"

        /// Maximum number of digits allowed in this field.
        public var digitLimit: Int {
            switch self {
            case .day, .month: return 2
            case .year:        return 4
            }
        }
    }

    private let field: Field
    @Binding private var text: String
    private let isError: Bool
    /// Optional: invoked when the user presses backspace on an
    /// already-empty field. The caller (typically `DOBInputGroup`)
    /// uses this to move focus to the previous segment.
    private let onEmptyBackspace: (() -> Void)?
    private var externalFocus: FocusState<Field?>.Binding?
    @FocusState private var localFocus: Bool

    /// Internal text the SwiftUI `TextField` actually edits. Mirrors
    /// the parent's `text` binding *plus* a zero-width-space sentinel
    /// any time the visible value is empty. The sentinel lets us
    /// detect an empty-field backspace from the iOS soft keyboard
    /// (which doesn't fire `.onKeyPress(.delete)`). We strip it before
    /// writing back to the parent, so callers never observe it.
    @State private var internalText: String = ""

    /// Tracks the last `isError` we saw so we can detect false→true
    /// transitions and fire the shake + haptic exactly **once per onset**
    /// (not continuously while the field stays invalid).
    @State private var lastIsError: Bool = false
    /// Bumped on every false→true error transition. `shake` watches
    /// the trigger value, replaying the shake keyframes each time.
    @State private var shakeTrigger: Int = 0

    public init(
        field: Field,
        text: Binding<String>,
        isError: Bool = false,
        onEmptyBackspace: (() -> Void)? = nil
    ) {
        self.field = field
        self._text = text
        self.isError = isError
        self.onEmptyBackspace = onEmptyBackspace
        self.externalFocus = nil
    }

    /// Shared-focus initializer used by `DOBInputGroup` to coordinate
    /// focus across the three fields (auto-advance + backspace-back).
    public init(
        field: Field,
        text: Binding<String>,
        focus: FocusState<Field?>.Binding,
        isError: Bool = false,
        onEmptyBackspace: (() -> Void)? = nil
    ) {
        self.field = field
        self._text = text
        self.isError = isError
        self.onEmptyBackspace = onEmptyBackspace
        self.externalFocus = focus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(field.rawValue)
                .font(Typography.captionSmall)
                .foregroundStyle(Colors.textSecondary)
                .tracking(4)

            textField
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity)
        // Layered background: the glass fill stays underneath in every
        // state, and the destructive tint sits on top *only* when
        // `isError` is true. Using a solid (non-animated) overlay rather
        // than a coloured stroke matches the "fill the field red"
        // requirement and keeps the visual state change instant.
        .background(.ultraThinMaterial)
        .background(
            // Destructive fill — appears the moment `isError` flips
            // true, no transition. Sits behind the content but on top
            // of the material, picking up the rounded clip below.
            isError
                ? Colors.destructive.opacity(0.18)
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
        .overlay(
            // Border swap (also non-animated): a solid red stroke when
            // erroring, the resting glass border otherwise. Replaces the
            // previous trim-from-0-to-1 animated stroke.
            RoundedRectangle(cornerRadius: Radius.xl)
                .stroke(
                    isError ? Colors.destructive : Colors.glassBorderStrong,
                    lineWidth: isError ? 1.5 : 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: Radius.xl))
        .onTapGesture {
            if let externalFocus {
                externalFocus.wrappedValue = field
            } else {
                localFocus = true
            }
        }
        // Auto-shake + auto-haptic on every false→true error onset.
        // We track the previous value in `lastIsError` so we only fire
        // on the rising edge — staying in error doesn't keep replaying
        // the shake, and clearing the error doesn't shake either.
        .shake(trigger: shakeTrigger)
        .onChange(of: isError) { _, nowError in
            guard nowError, !lastIsError else {
                lastIsError = nowError
                return
            }
            lastIsError = nowError
            #if canImport(UIKit)
            // Honour the system's reduce-motion preference for the
            // shake. The haptic plays regardless — iOS routes haptics
            // through its own accessibility settings, so users who
            // disable haptics globally still won't feel it.
            let reduceMotion = UIAccessibility.isReduceMotionEnabled
            if !reduceMotion {
                shakeTrigger &+= 1
            }
            #else
            shakeTrigger &+= 1
            #endif
            Haptics.error()
        }
        // Declares the styled DOB cell (label + padded text field +
        // background + border) as the tap-claim region for any ancestor
        // `dismissKeyboardOnBackgroundTap()` modifier. Without this,
        // taps near the cell's border would land outside the underlying
        // SwiftUI `TextField`'s intrinsic frame and dismiss-then-restore
        // the keyboard.
        .markAsKeyboardInputRegion()
    }

    @ViewBuilder
    private var textField: some View {
        if let externalFocus {
            rawTextField
                .focused(externalFocus, equals: field)
        } else {
            rawTextField
                .focused($localFocus)
        }
    }

    @ViewBuilder
    private var rawTextField: some View {
        // We can't use SwiftUI's `prompt:` parameter here because the
        // sentinel keeps `internalText` non-empty whenever the field
        // would otherwise be empty — and SwiftUI only renders the
        // prompt when the binding is empty. So we layer a manual
        // placeholder overlay aligned to the field's leading edge,
        // and toggle it on `displayedText(internalText).isEmpty`.
        let baseField = TextField("", text: $internalText)
            .font(.system(size: 24, weight: .heavy))
            .foregroundStyle(Colors.textPrimary)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .overlay(alignment: .leading) {
                if displayedText(internalText).isEmpty {
                    Text(placeholderString)
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundStyle(Colors.textPlaceholder)
                        .allowsHitTesting(false)
                }
            }
            // Hardware-keyboard backspace path. On iOS this only fires
            // when an external keyboard is attached — soft keyboards
            // don't route through key-press events, hence the sentinel
            // fallback in `applyInternalChange` below.
            .onKeyPress(.delete) {
                if displayedText(internalText).isEmpty {
                    onEmptyBackspace?()
                    return .handled
                }
                return .ignored
            }
            .onAppear {
                // Seed the internal buffer from the parent on first
                // mount so a pre-populated `text` shows up correctly,
                // then stamp the sentinel if the visible value is
                // empty so the soft-keyboard backspace path is armed.
                internalText = primeInternalText(from: text)
            }
            .onChange(of: text) { _, newExternal in
                // The parent overwrote `text` (e.g. clearing the form).
                // Resync our internal buffer, preserving the sentinel
                // when the new value is empty.
                let primed = primeInternalText(from: newExternal)
                if primed != internalText {
                    internalText = primed
                }
            }
            .onChange(of: internalText) { oldInternal, newInternal in
                applyInternalChange(old: oldInternal, new: newInternal)
            }

        #if canImport(UIKit)
        baseField.keyboardType(.numberPad)
        #else
        baseField
        #endif
    }

    /// Strips the zero-width-space sentinel from a buffer so the rest
    /// of the view (and the parent binding) only sees real digits.
    private func displayedText(_ raw: String) -> String {
        raw.replacingOccurrences(of: dobSentinel, with: "")
    }

    /// Builds the internal buffer from an external `String` value.
    /// Empty external value → just the sentinel (so the next backspace
    /// is detectable). Non-empty → the digits unchanged.
    private func primeInternalText(from external: String) -> String {
        external.isEmpty ? dobSentinel : external
    }

    /// Reconciles a `TextField` edit:
    /// - If the user deleted the sentinel (visible was already empty
    ///   and remains empty), fire `onEmptyBackspace` and re-prime the
    ///   sentinel so the next backspace is also catchable.
    /// - Otherwise, sanitize the visible portion (digits only, clamped
    ///   to `field.digitLimit`) and write the cleaned value back to
    ///   the parent binding. Re-stamp the sentinel if the field ends
    ///   up empty after sanitization.
    private func applyInternalChange(old: String, new: String) {
        let oldVisible = displayedText(old)
        let newVisible = displayedText(new)

        // Soft-keyboard empty-backspace path: the user deleted the
        // sentinel. New buffer is fully empty (no sentinel, no
        // digits), old visible was already empty. We treat this as
        // "backspace on empty field" and re-stamp the sentinel.
        if new.isEmpty, oldVisible.isEmpty {
            onEmptyBackspace?()
            // Re-prime so subsequent backspaces are still detected.
            // Using async write avoids feeding back into this
            // onChange synchronously.
            DispatchQueue.main.async {
                if internalText.isEmpty {
                    internalText = dobSentinel
                }
            }
            // Make sure the parent's binding stays empty.
            if !text.isEmpty { text = "" }
            return
        }

        // Normal edit: clean digits, clamp to limit.
        let digitsOnly = newVisible.filter(\.isNumber)
        let limited = String(digitsOnly.prefix(field.digitLimit))

        // Write cleaned value back to the parent.
        if limited != text {
            text = limited
        }

        // Reconcile the internal buffer. Empty visible → keep the
        // sentinel armed. Non-empty → strip any sentinel.
        let desired = limited.isEmpty ? dobSentinel : limited
        if desired != new {
            DispatchQueue.main.async {
                if internalText != desired {
                    internalText = desired
                }
            }
        }
    }

    private var placeholderString: String {
        switch field {
        case .day: return "01"
        case .month: return "01"
        case .year: return "1998"
        }
    }
}

// MARK: - DOB Input Group

public struct DOBInputGroup: View {
    @Binding private var day: String
    @Binding private var month: String
    @Binding private var year: String
    /// Per-field error state. Each `DOBField` only renders the destructive
    /// fill when its own `Field` value is in this set. Use an empty set
    /// for "no errors", `[.month]` for "month only", etc. This mirrors the
    /// `Set<…>` selection pattern used by `ChipGroup` /
    /// `InterestCategory`, keeping the partial-state convention
    /// consistent across the DesignSystem.
    private let errorFields: Set<DOBField.Field>

    /// Internally-coordinated focus across the three fields.
    /// Drives auto-advance: typing the digit limit in `day` jumps focus to
    /// `month`; the limit in `month` jumps focus to `year`. Also drives
    /// the new backspace-on-empty → previous-field behaviour.
    @FocusState private var focusedField: DOBField.Field?

    /// Designated initializer — pass the set of fields that should render
    /// their error fill. Pass `[]` for the all-valid state.
    public init(
        day: Binding<String>,
        month: Binding<String>,
        year: Binding<String>,
        errorFields: Set<DOBField.Field> = []
    ) {
        self._day = day
        self._month = month
        self._year = year
        self.errorFields = errorFields
    }

    /// Backward-compatible convenience for callers still using a single
    /// `isError` bool. `true` lights up all three fields (legacy behaviour);
    /// `false` clears them. Prefer the `errorFields:` initializer for
    /// per-field error highlighting.
    public init(
        day: Binding<String>,
        month: Binding<String>,
        year: Binding<String>,
        isError: Bool
    ) {
        self.init(
            day: day,
            month: month,
            year: year,
            errorFields: isError ? [.day, .month, .year] : []
        )
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            DOBField(
                field: .day,
                text: $day,
                focus: $focusedField,
                isError: errorFields.contains(.day),
                // Day is the leftmost cell — backspacing past it is a
                // no-op (no previous field to jump to).
                onEmptyBackspace: nil
            )
            DOBField(
                field: .month,
                text: $month,
                focus: $focusedField,
                isError: errorFields.contains(.month),
                onEmptyBackspace: { focusedField = .day }
            )
            DOBField(
                field: .year,
                text: $year,
                focus: $focusedField,
                isError: errorFields.contains(.year),
                onEmptyBackspace: { focusedField = .month }
            )
                .frame(maxWidth: .infinity)
        }
        .onChange(of: day) { _, newValue in
            if newValue.count >= DOBField.Field.day.digitLimit,
               focusedField == .day {
                focusedField = .month
            }
        }
        .onChange(of: month) { _, newValue in
            if newValue.count >= DOBField.Field.month.digitLimit,
               focusedField == .month {
                focusedField = .year
            }
        }
    }
}

// MARK: - Previews

#Preview("Glass TextField") {
    VStack(spacing: 20) {
        GlassTextField("e.g. Alex", text: .constant(""), label: "Your First Name")
        GlassTextField("Email address", text: .constant(""))
        GlassTextField("Password", text: .constant(""), isSecure: true)
    }
    .padding(32)
    .background(GradientBackground(style: .form))
}

#Preview("DOB Fields") {
    VStack(spacing: 20) {
        DOBInputGroup(
            day: .constant(""),
            month: .constant(""),
            year: .constant("")
        )

        DOBInputGroup(
            day: .constant("15"),
            month: .constant("13"),
            year: .constant("1998"),
            errorFields: [.month]
        )

        DOBInputGroup(
            day: .constant("32"),
            month: .constant("13"),
            year: .constant("2099"),
            errorFields: [.day, .month, .year]
        )
    }
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
