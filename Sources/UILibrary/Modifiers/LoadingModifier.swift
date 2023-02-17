//
//  LoadingModifier.swift
//
//
//  Created by Cadis on 17/02/23.
//

import SwiftUI

public struct LoadingModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isLoading: Bool
    var text: String
        
    public func body(content: Content) -> some View {
        content
            .onChange(of: isLoading, perform: onChangeLoadingState)
            .fullScreenCover(isPresented: $isLoading, content: progressView)
    }
    
    private func background() -> Color {
        return colorScheme == .light ? Color.black.opacity(0.2) : Color.gray.opacity(0.2)
    }
    
    private func progressView() -> some View {
        ZStack {
            background()
                .ignoresSafeArea()
            ProgressView(text)
                .font(.caption)
                .scaleEffect(1.5)
                .progressViewStyle(.circular)
        }
        .background(.clear)
        .onAppear(perform: enableAnimation)
        .onDisappear(perform: enableAnimation)
    }
    
    private func onChangeLoadingState(_ value: Bool) {
        UIView.setAnimationsEnabled(false)
    }
    
    private func enableAnimation() {
        if !UIView.areAnimationsEnabled {
            UIView.setAnimationsEnabled(true)
        }
    }
    
}
