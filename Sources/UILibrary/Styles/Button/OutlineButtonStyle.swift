//
//  OutlineButtonStyle.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

public struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isLoading) private var isLoading: Bool
    
    let color: Color
    let height: CGFloat
    let radius: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if isLoading {
                CircleBar(color: color)
                    .padding(8)
            } else {
                configuration.label
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
        }
        .frame(height: height)
        .frame(minWidth: height, maxWidth: isLoading ? height : .infinity)
        .background(RoundedRectangle(cornerRadius: radius).stroke(color, lineWidth: 1.5))
        .overlay(configuration.isPressed ? color.opacity(0.15) : Color.clear)
        .animation(.linear, value: isLoading)
        .allowsHitTesting(!isLoading)
    }
    
}
