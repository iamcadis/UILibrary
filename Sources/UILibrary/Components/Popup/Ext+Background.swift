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
    
    var action: () -> Void
        
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView(action: action)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    private class BackgroundRemovalView: UIView {
        
        private let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) not implemented")
        }
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            
            superview?.superview?.backgroundColor = .clear
            superview?.superview?.addGestureRecognizer(tap)
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            let point = sender?.location(in: superview?.subviews.first)
            if let point, !(self.frame.contains(point)) {
                self.action()
            }
        }
        
    }
    
}
#endif


