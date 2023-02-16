//
//  PopupView.swift
//
//
//  Created by Cadis on 16/02/23.
//

#if os(iOS)
import SwiftUI
import Combine

struct PopupView<Item: Identifiable, PopupContent: View>: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isPresented: Bool
    @Binding var item: Item?
    var closeOnOutside: Bool
    var onDismiss: (() -> Void)?
    var contentOne: (() -> PopupContent)? = nil
    var contentTwo: ((Item) -> PopupContent)? = nil
        
    func body(content: Content) -> some View {
        content
            .onReceive(Just(item), perform: onReceiveItem)
            .onChange(of: isPresented, perform: onChangeIsPresented)
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismiss, content: {
                contentWithoutValue()
            })
            .fullScreenCover(item: $item, onDismiss: onDismiss, content: {
                contentWithValue($0)
            })
    }
    
    private func onChangeIsPresented(_ value: Bool) {
        UIView.setAnimationsEnabled(false)
    }
    
    private func onReceiveItem(_ value: Item?) {
        UIView.setAnimationsEnabled(false)
    }
    
    private func contentWithoutValue() -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
                .onTapGesture(perform: close)
            if let contentOne {
                contentOne()
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 0.35)
            }
        }
        .background(PopupBackgroundRemovalView())
        .onAppear(perform: enableAnimation)
        .onDisappear(perform: enableAnimation)
    }
    
    private func contentWithValue(_ value: Item) -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
                .onTapGesture(perform: close)
            if let contentTwo {
                contentTwo(value)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 0.35)
            }
        }
        .background(PopupBackgroundRemovalView())
        .onAppear(perform: enableAnimation)
        .onDisappear(perform: enableAnimation)
    }
    
    private func background() -> Color {
        return colorScheme == .light ? Color.black.opacity(0.15) : Color.gray.opacity(0.15)
    }
    
    private func close() {
        if closeOnOutside {
            withAnimation {
                isPresented = false
                item = nil
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

