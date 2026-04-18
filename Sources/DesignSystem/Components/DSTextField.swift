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
    public enum Field: String, Sendable {
        case day = "DAY"
        case month = "MONTH"
        case year = "YEAR"
    }

    private let field: Field
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    public init(field: Field, text: Binding<String>) {
        self.field = field
        self._text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(field.rawValue)
                .font(DSTypography.captionSmall)
                .foregroundStyle(DSColors.textSecondary)
                .tracking(4)

            TextField("", text: $text, prompt: promptText)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(DSColors.textPrimary)
                .keyboardType(.numberPad)
                .focused($isFocused)
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.xl)
                .stroke(DSColors.glassBorderStrong, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
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

    public init(day: Binding<String>, month: Binding<String>, year: Binding<String>) {
        self._day = day
        self._month = month
        self._year = year
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            DSDOBField(field: .day, text: $day)
            DSDOBField(field: .month, text: $month)
            DSDOBField(field: .year, text: $year)
                .frame(maxWidth: .infinity)
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
    DSDOBInputGroup(
        day: .constant(""),
        month: .constant(""),
        year: .constant("")
    )
    .padding(32)
    .background(Color(hex: 0xF8F9FA))
}
