//
//  ViewExt.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

public extension View where Self == NoBackground {
    
    /// Use this modifier to remove background
    /// For example, you can place a collection of stars beind a ``Text`` view:
    ///
    ///     Text("ABCDEF")
    ///         .background(.clear)
    ///
    static var clear: NoBackground { NoBackground() }
}

public extension View {
    
    /// A Boolean value that determines whether the view hierarchy to show loading indicator
    /// in button (use this when you using button style `outline` or `solid`)
    ///
    /// The default value is `false`.
    ///
    func buttonLoading(_ show: Bool) -> some View {
        environment(\.isLoading, show)
    }
    
    /// Presents a popup view when a binding to a Boolean value that you
    /// provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the popup.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure that returns the content of the modal view.
    ///
    @ViewBuilder func popup<Content: View>(isPresented: Binding<Bool>, closeOnOutside: Bool = true, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(
            PopupView<String, Content>(isPresented: isPresented, item: .constant(nil), closeOnOutside: closeOnOutside, onDismiss: onDismiss, contentOne: content)
        )
    }
    
    /// Presents a popup view using the binding you provide as a data source for the
    /// popup's content.
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the contents to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the currently displayed sheet and replaces
    ///     it with a new one using the same process.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure returning the content of the modal view.
    ///
    @ViewBuilder func popup<Item: Identifiable, Content: View>(item: Binding<Item?>, closeOnOutside: Bool = true, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        modifier(
            PopupView<Item, Content>(isPresented: .constant(false), item: item, closeOnOutside: closeOnOutside, onDismiss: onDismiss, contentTwo: content)
        )
    }
    
    /// Presents a indicator loading full screen cover
    /// - Parameters:
    ///   - isLoading: A binding to a Boolean value that determines whether
    ///   - text: A label for indicator loading
    ///
    @ViewBuilder func pageLoading(when isLoading: Binding<Bool>, text: String = "") -> some View {
        modifier(LoadingModifier(isLoading: isLoading, text: text))
    }
    
    /// Hide view and the properties
    ///
    /// - Parameter gone: to hide element from view
    ///
    @ViewBuilder func gone(_ gone: Bool) -> some View {
        if !gone { self }
    }
    
    /// The ``capitalization`` struct defines the available
    /// autocapitalizing behavior with backward compatibility for ios 14
    ///
    /// - Parameter type: One of the capitalizing behaviors
    /// defined in the ``UITextAutocapitalizationType`` struct or nil.
    @ViewBuilder func capitalization(_ type: UITextAutocapitalizationType) -> some View {
        if #available(iOS 15.0, *) {
            self.textInputAutocapitalization(TextInputAutocapitalization(type))
        } else {
            self.autocapitalization(type)
        }
    }
}

public extension LabelTextField {
    
    /// Set label text field to required
    func required(_ required: Bool) -> Self {
        notifier.isRequired = required
        return self
    }
    
    /// Set placeholder text field
    func placeholder(_ placeholder: String) -> Self {
        notifier.placeholder = placeholder
        return self
    }
    
    /// Set placeholder text field
    func setMaxLength(_ length: Int) -> Self {
        notifier.maxLength = length
        return self
    }
    
    /// Set placeholder text field
    func labelIsHidden() -> Self {
        notifier.isLabelHidden = true
        return self
    }
    
    /// Sets the validation condition.
    func addValidation(_ condition: Bool, message: String) -> Self {
        notifier.validators.append(.init(isValid: condition, message: message))
        return self
    }
    
    /// Override required message when condition fulfilled
    /// use this when you using translation
    ///
    /// default message: \(`label`) cannot be blank or empty
    ///
    func overrideRequiredMessage(_ message: String) -> Self {
        notifier.requiredMessage = message
        return self
    }
}
