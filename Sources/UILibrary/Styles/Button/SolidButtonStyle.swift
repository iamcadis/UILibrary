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
    
    private let background: Color
    private let foreground: Color
    private let height: CGFloat
    private let radius: CGFloat
    
    public init(background: Color, foreground: Color, height: CGFloat, radius: CGFloat) {
        self.background = background
        self.foreground = foreground
        self.height = height
        self.radius = radius
    }
    
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
        .overlay(configuration.isPressed ? .black.opacity(0.15) : Color.clear)
        .cornerRadius(radius)
        .animation(.linear, value: isLoading)
        .allowsHitTesting(!isLoading)
    }
    
}
