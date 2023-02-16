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
    
    @State private var itemIsNotNil = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                UIView.setAnimationsEnabled(false)
            }
            .onChange(of: itemIsNotNil) { _ in
                UIView.setAnimationsEnabled(false)
            }
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismiss, content: {
                contentWithoutValue()
            })
            .fullScreenCover(item: $item, onDismiss: onDismiss, content: {
                contentWithValue($0)
            })
            .onReceive(Just(item), perform: onReceiveItem)
    }
    
    private func onReceiveItem(_ value: Item?) {
        itemIsNotNil = value != nil
    }
    
    private func contentWithoutValue() -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
            if let contentOne {
                contentOne()
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 0.35)
            }
        }
        .background(PopupBackgroundRemovalView(action: close))
        .onAppear(perform: enableAnimation)
        .onDisappear(perform: enableAnimation)
    }
    
    private func contentWithValue(_ value: Item) -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
            if let contentTwo {
                contentTwo(value)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 0.35)
            }
        }
        .background(PopupBackgroundRemovalView(action: close))
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

