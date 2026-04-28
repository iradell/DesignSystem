import SwiftUI

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
    private var externalFocus: FocusState<Field?>.Binding?
    @FocusState private var localFocus: Bool

    public init(field: Field, text: Binding<String>, isError: Bool = false) {
        self.field = field
        self._text = text
        self.isError = isError
        self.externalFocus = nil
    }

    /// Shared-focus initializer used by `DSDOBInputGroup` to coordinate
    /// focus across the three fields (auto-advance behaviour).
    public init(
        field: Field,
        text: Binding<String>,
        focus: FocusState<Field?>.Binding,
        isError: Bool = false
    ) {
        self.field = field
        self._text = text
        self.isError = isError
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
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(
            // Resting glass border — always present so the field never
            // looks bare while the red stroke is hidden.
            RoundedRectangle(cornerRadius: DSRadius.xl)
                .stroke(DSColors.glassBorderStrong, lineWidth: 1)
        )
        .overlay(
            // Animated red stroke. We trim the rounded rect from 0→1 when
            // `isError` flips on, so the destructive border literally
            // *draws* around the field. When `isError` flips back off the
            // trim retreats from 1→0 and the stroke unwinds.
            RoundedRectangle(cornerRadius: DSRadius.xl)
                .trim(from: 0, to: isError ? 1 : 0)
                .stroke(DSColors.destructive, lineWidth: 2)
                .animation(.easeInOut(duration: 0.45), value: isError)
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
    }

    @ViewBuilder
    private var textField: some View {
        if let externalFocus {
            TextField("", text: $text, prompt: promptText)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(DSColors.textPrimary)
                .keyboardType(.numberPad)
                .focused(externalFocus, equals: field)
                .onChange(of: text) { _, newValue in
                    sanitize(newValue)
                }
        } else {
            TextField("", text: $text, prompt: promptText)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(DSColors.textPrimary)
                .keyboardType(.numberPad)
                .focused($localFocus)
                .onChange(of: text) { _, newValue in
                    sanitize(newValue)
                }
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

    private var promptText: Text {
        let placeholder: String = switch field {
        case .day: "01"
        case .month: "01"
        case .year: "1998"
        }
        return Text(placeholder)
            .font(.system(size: 24, weight: .heavy))
            .foregroundStyle(DSColors.textPlaceholder)
    }
}

// MARK: - DOB Input Group

public struct DSDOBInputGroup: View {
    @Binding private var day: String
    @Binding private var month: String
    @Binding private var year: String
    /// Per-field error state. Each `DSDOBField` only renders the destructive
    /// stroke when its own `Field` value is in this set. Use an empty set
    /// for "no errors", `[.month]` for "month only", etc. This mirrors the
    /// `Set<…>` selection pattern used by `DSChipGroup` /
    /// `DSInterestCategory`, keeping the partial-state convention
    /// consistent across the DesignSystem.
    private let errorFields: Set<DSDOBField.Field>

    /// Internally-coordinated focus across the three fields.
    /// Drives auto-advance: typing the digit limit in `day` jumps focus to
    /// `month`; the limit in `month` jumps focus to `year`.
    @FocusState private var focusedField: DSDOBField.Field?

    /// Designated initializer — pass the set of fields that should render
    /// their error stroke. Pass `[]` for the all-valid state.
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
            DSDOBField(field: .day, text: $day, focus: $focusedField, isError: errorFields.contains(.day))
            DSDOBField(field: .month, text: $month, focus: $focusedField, isError: errorFields.contains(.month))
            DSDOBField(field: .year, text: $year, focus: $focusedField, isError: errorFields.contains(.year))
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
    }
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
