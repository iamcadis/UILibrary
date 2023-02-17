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
    
    private var indicator: some View {
        ProgressView(text)
            .font(.footnote)
            .scaleEffect(1.5)
            .progressViewStyle(.circular)
            .padding(.top, 8)
    }
    
    private func background() -> Color {
        return colorScheme == .light ? Color.black.opacity(0.15) : Color.gray.opacity(0.15)
    }
        
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isLoading {
                        Color.black.opacity(0.2).ignoresSafeArea()
                        indicator.opacity(isLoading ? 1 : 0)
                    }
                }
            )
            .disabled(isLoading)
    }
    
}
