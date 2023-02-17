//
//  PopupView.swift
//
//
//  Created by Cadis on 16/02/23.
//

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
                contentView(nil)
            })
            .fullScreenCover(item: $item, onDismiss: onDismiss, content: { item in
                contentView(item)
            })
    }
    
    private func contentView(_ item: Item?) -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
                .onTapGesture(perform: close)
            popupContent(item)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(12)
                .padding(24)
        }
        .background(.clear)
        .onAppear(perform: enableAnimation)
        .onDisappear(perform: enableAnimation)
    }
    
    private func popupContent(_ itemContent: Item?) -> some View {
        if let contentOne {
            return AnyView(contentOne())
        }
        
        if let itemContent, let contentTwo {
            return AnyView(contentTwo(itemContent))
        }
        
        return AnyView(EmptyView())
    }
    
    private func background() -> Color {
        return colorScheme == .light ? Color.black.opacity(0.2) : Color.gray.opacity(0.2)
    }
    
    private func onChangeIsPresented(_ value: Bool) {
        UIView.setAnimationsEnabled(false)
    }
    
    private func onReceiveItem(_ value: Item?) {
        UIView.setAnimationsEnabled(false)
    }
    
    private func enableAnimation() {
        if !UIView.areAnimationsEnabled {
            UIView.setAnimationsEnabled(true)
        }
    }
    
    private func close() {
        if closeOnOutside {
            withAnimation {
                isPresented = false
                item = nil
            }
        }
    }
    
}
