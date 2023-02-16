//
//  Ext+Background.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

#if os(iOS)
extension Int: Identifiable {
    public var id: Int { self }
}

extension View {
    
    func popup<Content: View>(isPresented: Binding<Bool>, closeOnOutside: Bool = true, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(
            PopupView<Int, Content>(isPresented: isPresented, item: .constant(nil), closeOnOutside: closeOnOutside, onDismiss: onDismiss, contentOne: content)
        )
    }
    
    func popup<Item: Identifiable, Content: View>(item: Binding<Item?>, closeOnOutside: Bool = true, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        modifier(
            PopupView<Item, Content>(isPresented: .constant(false), item: item, closeOnOutside: closeOnOutside, onDismiss: onDismiss, contentTwo: content)
        )
    }
}

struct PopupBackgroundRemovalView: UIViewRepresentable {
        
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    private class BackgroundRemovalView: UIView {
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
        
    }
    
}
#endif




