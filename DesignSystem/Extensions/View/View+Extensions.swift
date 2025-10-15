//
//  View+Extensions.swift
//  DesignSystem
//
//  Created by IRADELL on 15.10.25.
//

import SwiftUI

public extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

// MARK: if

public extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        apply modifier: (Self) -> Content
    ) -> some View {
        Group {
            if condition {
                modifier(self)
            }
            self
        }
    }
}
