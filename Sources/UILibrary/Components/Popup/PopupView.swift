//
//  SwiftUIView.swift
//
//
//  Created by Cadis on 16/02/23.
//

#if os(iOS)
import SwiftUI

struct Popup<FullScreenContent: View>: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isPresented: Bool
    let closeOnOutside: Bool
    let fullScreenContent: () -> (FullScreenContent)
    
    var background: Color {
        colorScheme == .light ? Color.black : Color.gray
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            background.opacity(isPresented ? 0.15 : 0)
                .ignoresSafeArea()
            contentView(content: content)
        }
    }
    
    private func contentView(content: Content) -> some View {
        content
            .onChange(of: isPresented) { isPresented in
                UIView.setAnimationsEnabled(false)
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                ZStack {
                    fullScreenContent()
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 0.35)
                }
                .background(FullScreenCoverBackgroundRemovalView(action: onDismiss))
                .onAppear(perform: enableAnimation)
                .onDisappear(perform: enableAnimation)
            })
    }
    
    private func onDismiss() {
        if closeOnOutside {
            withAnimation {
                isPresented = false
            }
        }
    }
    
    private func enableAnimation() {
        if !UIView.areAnimationsEnabled {
            UIView.setAnimationsEnabled(true)
        }
    }
    
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    
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
