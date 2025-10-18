//
//  View+Extensions.swift
//  DesignSystem
//
//  Created by IRADELL on 15.10.25.
//

import SwiftUI

// MARK: - Type Erasure

public extension View {
    /// Erases the view’s type to `AnyView`.
    ///
    /// Use this method when you need to return different view types
    /// from a single computed property or function. This helps you
    /// maintain type consistency when using conditional logic or
    /// dynamic view composition.
    ///
    /// Example:
    /// ```swift
    /// var body: some View {
    ///     Group {
    ///         if isLoading {
    ///             ProgressView()
    ///         } else {
    ///             Text("Loaded")
    ///         }
    ///     }
    ///     .eraseToAnyView()
    /// }
    /// ```
    ///
    /// - Returns: An `AnyView` that wraps the current view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Conditional Modifier (Single Condition)

public extension View {
    /// Applies a modifier to the current view only when a condition is `true`.
    ///
    /// This extension allows conditional styling or transformations
    /// while maintaining a clean, declarative structure.
    ///
    /// Example:
    /// ```swift
    /// Text("Continue")
    ///     .if(isPrimary) { view in
    ///         view.foregroundColor(.blue)
    ///     }
    /// ```
    ///
    /// When `condition` is `false`, the modifier is skipped and the
    /// original view is returned.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value that determines whether to apply the modifier.
    ///   - modifier: A closure that modifies the current view when `condition` is `true`.
    /// - Returns: The modified view if `condition` is `true`; otherwise, the unmodified view.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        apply modifier: (Self) -> Content
    ) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
}

// MARK: - Conditional Modifier (If/Else)

public extension View {
    /// Applies one of two modifiers to the current view depending on a condition.
    ///
    /// This overload provides control over both `true` and `false` cases,
    /// allowing you to define alternate visual states.
    ///
    /// Example:
    /// ```swift
    /// Text("Status")
    ///     .if(isActive,
    ///         if: { $0.foregroundColor(.green) },
    ///         else: { $0.foregroundColor(.gray) }
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - condition: A Boolean determining which modifier to apply.
    ///   - trueModifier: A closure that applies modifications when `condition` is `true`.
    ///   - falseModifier: A closure that applies modifications when `condition` is `false`.
    /// - Returns: A view modified according to `condition`.
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if trueModifier: (Self) -> TrueContent,
        else falseModifier: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueModifier(self)
        } else {
            falseModifier(self)
        }
    }
}

// MARK: - Optional Modifier

public extension View {
    /// Applies a modifier to the current view when an optional value is non-nil.
    ///
    /// This method allows you to conditionally apply transformations or
    /// styles that depend on an optional value.
    ///
    /// Example:
    /// ```swift
    /// Text("Welcome")
    ///     .ifLet(username) { view, name in
    ///         view.text("Welcome, \(name)")
    ///     }
    /// ```
    ///
    /// When `value` is `nil`, the original view is returned unmodified.
    ///
    /// - Parameters:
    ///   - value: The optional value to unwrap.
    ///   - modifier: A closure that modifies the view using the unwrapped value.
    /// - Returns: A modified view if `value` is non-nil; otherwise, the original view.
    @ViewBuilder
    func ifLet<Value, Content: View>(
        _ value: Value?,
        apply modifier: (Self, Value) -> Content
    ) -> some View {
        if let value {
            modifier(self, value)
        } else {
            self
        }
    }
}

// MARK: - Rounded Corners

public extension View {
    /// Clips the view to a rounded rectangle shape.
    ///
    /// This method provides a convenient shorthand for applying
    /// rounded corners with a continuous style.
    ///
    /// Example:
    /// ```swift
    /// Image("avatar")
    ///     .resizable()
    ///     .rounded(16)
    /// ```
    ///
    /// - Parameter radius: The corner radius for the rounded rectangle.
    /// - Returns: A view clipped to a rounded rectangle.
    func rounded(_ radius: CGFloat = 12) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

// MARK: - Visibility Control

public extension View {
    /// Conditionally hides or removes the view from the hierarchy.
    ///
    /// This modifier lets you toggle visibility in two ways:
    /// - **Hidden:** The view remains in the layout but is invisible.
    /// - **Removed:** The view is completely removed from the hierarchy.
    ///
    /// Example:
    /// ```swift
    /// Text("Loading...")
    ///     .hide(isLoading, remove: false)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Whether the view should be hidden.
    ///   - remove: If `true`, the view is removed from the hierarchy; otherwise, it’s hidden.
    /// - Returns: Either the hidden view or an empty space, depending on parameters.
    @ViewBuilder
    func hide(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove { self.hidden() }
        } else {
            self
        }
    }
}
