import SwiftUI

// MARK: - OTP Field

public struct DSOTPField: View {
    @Binding private var code: String
    private let length: Int
    @FocusState private var isFocused: Bool

    public init(code: Binding<String>, length: Int = 4) {
        self._code = code
        self.length = length
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(0..<length, id: \.self) { index in
                digitBox(at: index)
            }
        }
        .background(
            // Hidden text field to capture input
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .allowsHitTesting(false)
        )
        .onTapGesture {
            isFocused = true
        }
        .onChange(of: code) { _, newValue in
            if newValue.count > length {
                code = String(newValue.prefix(length))
            }
        }
    }

    private func digitBox(at index: Int) -> some View {
        let digit = index < code.count
            ? String(code[code.index(code.startIndex, offsetBy: index)])
            : ""
        let isActive = index == code.count && isFocused

        return Text(digit)
            .font(.system(size: 24, weight: .heavy))
            .foregroundStyle(DSColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .stroke(
                        isActive ? DSColors.accentIndigo : DSColors.glassBorderStrong,
                        lineWidth: isActive ? 2 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: isActive)
    }
}

// MARK: - Previews

#Preview("OTP Field") {
    VStack(spacing: 20) {
        DSOTPField(code: .constant(""))
        DSOTPField(code: .constant("12"))
        DSOTPField(code: .constant("1234"))
    }
    .padding(DSSpacing.xxl)
    .background(DSColors.onboardingGradient)
}
