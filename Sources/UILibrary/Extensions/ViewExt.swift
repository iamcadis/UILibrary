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
    @ViewBuilder func gone(if gone: Bool) -> some View {
        if !gone { self }
    }
    
    /// Hide view and the properties still exist
    @ViewBuilder func hidden(if hide: Bool) -> some View {
        if hide {
            self
        } else {
            self.hidden()
        }
    }
    
}
