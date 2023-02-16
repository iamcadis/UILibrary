//
//  SolidButtonStyle.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

public struct SolidButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isLoading) private var isLoading: Bool
    
    let background: Color
    let foreground: Color
    let height: CGFloat
    let radius: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if isLoading {
                CircleBar(color: foreground)
                    .padding(8)
            } else {
                configuration.label
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(foreground)
            }
        }
        .frame(height: height)
        .frame(minWidth: height, maxWidth: isLoading ? height : .infinity)
        .foregroundColor(isEnabled ? foreground : .gray.opacity(0.75))
        .background(isEnabled ? background : .gray.opacity(0.25))
        .cornerRadius(radius)
        .overlay(configuration.isPressed ? .black.opacity(0.15) : Color.clear)
        .animation(.linear, value: isLoading)
        .allowsHitTesting(!isLoading)
    }
    
}