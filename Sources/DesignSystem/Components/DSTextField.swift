import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Glass TextField

public struct DSGlassTextField: View {
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
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            if let label {
                Text(label.uppercased())
                    .font(DSTypography.labelSmall)
                    .foregroundStyle(DSColors.textPrimary)
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
                .font(DSTypography.bodyMedium.weight(.bold))
                .foregroundStyle(DSColors.textPrimary)
                .focused($isFocused)

                if isSecure {
                    Button {
                        isSecureVisible.toggle()
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.fill" : "eye.slash.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(DSColors.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 21)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.lg)
                    .stroke(DSColors.glassBorder, lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: DSRadius.lg))
            .onTapGesture {
                isFocused = true
            }
        }
    }

    private var promptText: Text {
        Text(placeholder)
            .font(DSTypography.bodyMedium.weight(.bold))
            .foregroundStyle(DSColors.textPlaceholder)
    }
}

// MARK: - Backspace-Aware UITextField (private)

#if canImport(UIKit)
/// A `UIViewRepresentable`-wrapped `UITextField` subclass that exposes
/// the "backspace pressed while text was already empty" event — a
/// signal SwiftUI's `TextField` doesn't deliver natively (an
/// empty-on-empty backspace produces no `onChange`).
///
/// Used by `DSDOBField` so the caller can move focus to the previous
/// segment when the user backspaces past the leftmost digit.
struct DSBackspaceAwareTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let font: UIFont
    let textColor: UIColor
    let placeholderColor: UIColor
    let keyboardType: UIKeyboardType
    let onEmptyBackspace: () -> Void
    /// Forwarded so the wrapper can resign / take first responder when
    /// the SwiftUI `@FocusState` flips. This is a one-way mirror —
    /// SwiftUI is still the source of truth.
    let isFocused: Bool
    let onFocusChange: (Bool) -> Void

    func makeUIView(context: Context) -> _BackspaceUITextField {
        let tf = _BackspaceUITextField()
        tf.delegate = context.coordinator
        tf.onEmptyBackspace = { [weak coordinator = context.coordinator] in
            coordinator?.handleEmptyBackspace()
        }
        tf.font = font
        tf.textColor = textColor
        tf.keyboardType = keyboardType
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor, .font: font]
        )
        // Disable the system "smart" features that interfere with a
        // numeric segment field.
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.smartDashesType = .no
        tf.smartQuotesType = .no
        tf.smartInsertDeleteType = .no
        tf.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingChanged(_:)),
            for: .editingChanged
        )
        return tf
    }

    func updateUIView(_ uiView: _BackspaceUITextField, context: Context) {
        // Keep the Coordinator's `parent` reference fresh so the bindings
        // and closures it forwards to (text, onEmptyBackspace,
        // onFocusChange) always point at *this* render's values, not the
        // first one captured in `makeCoordinator`. Without this, every
        // editingChanged write goes through stale closures and SwiftUI
        // never sees the updated text in the right binding identity,
        // which is what was tearing the responder down.
        context.coordinator.parent = self

        // Keep the placeholder colour fresh — SwiftUI may rebuild this
        // representable across colour-scheme changes.
        if uiView.attributedPlaceholder?.string != placeholder {
            uiView.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: placeholderColor, .font: font]
            )
        }
        if uiView.text != text {
            uiView.text = text
        }

        // Mirror SwiftUI's @FocusState onto UIKit, but ONLY on a true
        // edge transition of the SwiftUI focus binding — not "every
        // updateUIView where SwiftUI happens to be out of phase with
        // UIKit." The previous implementation called become/resign on
        // every render where the two disagreed, async-dispatched, which
        // raced with `textFieldDidBeginEditing` callbacks and caused the
        // field to lose focus after each keystroke.
        let coord = context.coordinator
        if isFocused != coord.lastIsFocused {
            if isFocused, !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            } else if !isFocused, uiView.isFirstResponder {
                uiView.resignFirstResponder()
            }
            coord.lastIsFocused = isFocused
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DSBackspaceAwareTextField
        /// Last SwiftUI-side focus value we observed. Used by
        /// `updateUIView` to detect a genuine focus edge instead of
        /// firing become/resign on every text-driven re-render.
        var lastIsFocused: Bool

        init(_ parent: DSBackspaceAwareTextField) {
            self.parent = parent
            self.lastIsFocused = parent.isFocused
        }

        @objc func editingChanged(_ sender: UITextField) {
            parent.text = sender.text ?? ""
        }

        func handleEmptyBackspace() {
            parent.onEmptyBackspace()
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            // UIKit just made this field first responder. Record the
            // truth so the next updateUIView sees focused→focused (not
            // a phantom edge) and doesn't try to "fix" anything.
            lastIsFocused = true
            parent.onFocusChange(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            lastIsFocused = false
            parent.onFocusChange(false)
        }
    }
}

/// Concrete `UITextField` subclass that overrides `deleteBackward()` so
/// we can detect a backspace press on an already-empty field — the
/// only reliable way to receive that signal on iOS.
final class _BackspaceUITextField: UITextField {
    /// Fired *before* `super.deleteBackward()` runs, only when the
    /// current text was empty. Lets SwiftUI move focus to the previous
    /// segment without losing the next character the user types.
    var onEmptyBackspace: (() -> Void)?

    override func deleteBackward() {
        let wasEmpty = (text ?? "").isEmpty
        super.deleteBackward()
        if wasEmpty { onEmptyBackspace?() }
    }
}
#endif

// MARK: - DOB TextField

public struct DSDOBField: View {
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
    /// already-empty field. The caller (typically `DSDOBInputGroup`)
    /// uses this to move focus to the previous segment.
    private let onEmptyBackspace: (() -> Void)?
    private var externalFocus: FocusState<Field?>.Binding?
    @FocusState private var localFocus: Bool

    /// Tracks the last `isError` we saw so we can detect false→true
    /// transitions and fire the shake + haptic exactly **once per onset**
    /// (not continuously while the field stays invalid).
    @State private var lastIsError: Bool = false
    /// Bumped on every false→true error transition. `dsShake` watches
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

    /// Shared-focus initializer used by `DSDOBInputGroup` to coordinate
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
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(field.rawValue)
                .font(DSTypography.captionSmall)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(4)

            textField
        }
        .padding(DSSpacing.lg)
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
                ? DSColors.destructive.opacity(0.18)
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(
            // Border swap (also non-animated): a solid red stroke when
            // erroring, the resting glass border otherwise. Replaces the
            // previous trim-from-0-to-1 animated stroke.
            RoundedRectangle(cornerRadius: DSRadius.xl)
                .stroke(
                    isError ? DSColors.destructive : DSColors.glassBorderStrong,
                    lineWidth: isError ? 1.5 : 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: DSRadius.xl))
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
        .dsShake(trigger: shakeTrigger)
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
            DSHaptics.error()
        }
    }

    @ViewBuilder
    private var textField: some View {
        #if canImport(UIKit)
        let placeholder = placeholderString
        DSBackspaceAwareTextField(
            text: $text,
            placeholder: placeholder,
            font: .systemFont(ofSize: 24, weight: .heavy),
            textColor: UIColor(DSColors.textPrimary),
            placeholderColor: UIColor(DSColors.textPlaceholder),
            keyboardType: .numberPad,
            onEmptyBackspace: { onEmptyBackspace?() },
            isFocused: isCurrentlyFocused,
            onFocusChange: { focused in
                if focused {
                    if let externalFocus {
                        if externalFocus.wrappedValue != field {
                            externalFocus.wrappedValue = field
                        }
                    } else {
                        localFocus = true
                    }
                }
            }
        )
        .onChange(of: text) { _, newValue in
            sanitize(newValue)
        }
        #else
        // macOS preview fallback — no UIKit available.
        TextField("", text: $text, prompt: Text(placeholderString))
            .font(.system(size: 24, weight: .heavy))
            .foregroundStyle(DSColors.textPrimary)
            .onChange(of: text) { _, newValue in
                sanitize(newValue)
            }
        #endif
    }

    /// Whether *this* segment is the currently focused one, derived
    /// from whichever focus binding is active. Drives
    /// `becomeFirstResponder` / `resignFirstResponder` on the wrapped
    /// `UITextField`.
    private var isCurrentlyFocused: Bool {
        if let externalFocus {
            return externalFocus.wrappedValue == field
        } else {
            return localFocus
        }
    }

    /// Strips non-digits and clamps to the field's digit limit.
    /// Bound to `text` so the parent's binding always reflects the cleaned value.
    private func sanitize(_ newValue: String) {
        let digitsOnly = newValue.filter(\.isNumber)
        let limited = String(digitsOnly.prefix(field.digitLimit))
        if limited != newValue {
            // Avoid an infinite onChange loop — only write back when different.
            text = limited
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

public struct DSDOBInputGroup: View {
    @Binding private var day: String
    @Binding private var month: String
    @Binding private var year: String
    /// Per-field error state. Each `DSDOBField` only renders the destructive
    /// fill when its own `Field` value is in this set. Use an empty set
    /// for "no errors", `[.month]` for "month only", etc. This mirrors the
    /// `Set<…>` selection pattern used by `DSChipGroup` /
    /// `DSInterestCategory`, keeping the partial-state convention
    /// consistent across the DesignSystem.
    private let errorFields: Set<DSDOBField.Field>

    /// Internally-coordinated focus across the three fields.
    /// Drives auto-advance: typing the digit limit in `day` jumps focus to
    /// `month`; the limit in `month` jumps focus to `year`. Also drives
    /// the new backspace-on-empty → previous-field behaviour.
    @FocusState private var focusedField: DSDOBField.Field?

    /// Designated initializer — pass the set of fields that should render
    /// their error fill. Pass `[]` for the all-valid state.
    public init(
        day: Binding<String>,
        month: Binding<String>,
        year: Binding<String>,
        errorFields: Set<DSDOBField.Field> = []
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
        HStack(spacing: DSSpacing.sm) {
            DSDOBField(
                field: .day,
                text: $day,
                focus: $focusedField,
                isError: errorFields.contains(.day),
                // Day is the leftmost cell — backspacing past it is a
                // no-op (no previous field to jump to).
                onEmptyBackspace: nil
            )
            DSDOBField(
                field: .month,
                text: $month,
                focus: $focusedField,
                isError: errorFields.contains(.month),
                onEmptyBackspace: { focusedField = .day }
            )
            DSDOBField(
                field: .year,
                text: $year,
                focus: $focusedField,
                isError: errorFields.contains(.year),
                onEmptyBackspace: { focusedField = .month }
            )
                .frame(maxWidth: .infinity)
        }
        .onChange(of: day) { _, newValue in
            if newValue.count >= DSDOBField.Field.day.digitLimit,
               focusedField == .day {
                focusedField = .month
            }
        }
        .onChange(of: month) { _, newValue in
            if newValue.count >= DSDOBField.Field.month.digitLimit,
               focusedField == .month {
                focusedField = .year
            }
        }
    }
}

// MARK: - Previews

#Preview("Glass TextField") {
    VStack(spacing: 20) {
        DSGlassTextField("e.g. Alex", text: .constant(""), label: "Your First Name")
        DSGlassTextField("Email address", text: .constant(""))
        DSGlassTextField("Password", text: .constant(""), isSecure: true)
    }
    .padding(32)
    .background(DSColors.onboardingGradient)
}

#Preview("DOB Fields") {
    VStack(spacing: 20) {
        DSDOBInputGroup(
            day: .constant(""),
            month: .constant(""),
            year: .constant("")
        )

        DSDOBInputGroup(
            day: .constant("15"),
            month: .constant("13"),
            year: .constant("1998"),
            errorFields: [.month]
        )

        DSDOBInputGroup(
            day: .constant("32"),
            month: .constant("13"),
            year: .constant("2099"),
            errorFields: [.day, .month, .year]
        )
    }
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
