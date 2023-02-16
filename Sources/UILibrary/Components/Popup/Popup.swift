//
//  SwiftUIView.swift
//
//
//  Created by Cadis on 16/02/23.
//

#if os(iOS)
import SwiftUI

struct Popup<PopupContent: View>: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isPresented: Bool
    let closeOnOutside: Bool
    let onDismissCallback: (() -> Void)?
    let fullScreenContent: () -> (PopupContent)
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                UIView.setAnimationsEnabled(false)
            }
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismissCallback, content: {
                ZStack {
                    background()
                        .ignoresSafeArea()
                    fullScreenContent()
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 0.35)
                }
                .background(PopupBackgroundRemovalView(action: close))
                .onAppear(perform: enableAnimation)
                .onDisappear(perform: enableAnimation)
            })
    }
    
    private func background() -> Color {
        return colorScheme == .light ? Color.black.opacity(0.15) : Color.gray.opacity(0.15)
    }
    
    private func close() {
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
#endif

