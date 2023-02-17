//
//  Extensions.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

public extension ButtonStyle where Self == SolidButtonStyle {
    
    static var solid: SolidButtonStyle {
        SolidButtonStyle(background: .accentColor, foreground: .white, height: 42, radius: 24)
    }
    
    /// Use this modifier to make button use solid color
    /// - Parameters:
    ///   - background: A color for background
    ///   - foreground: A color for foreground (label)
    ///   - height: heigh of button
    ///   - radius: corner radius of button
    ///
    static func solid(background: Color, foreground: Color, height: CGFloat = 42, radius: CGFloat = 24) -> SolidButtonStyle {
        SolidButtonStyle(background: background, foreground: foreground, height: height, radius: radius)
    }
}

public extension ButtonStyle where Self == OutlineButtonStyle {
    
    static var outline: OutlineButtonStyle {
        OutlineButtonStyle(color: .accentColor, height: 42, radius: 24)
    }
    
    /// Use this modifier to make button use outline color
    /// - Parameters:
    ///   - color: A color for stroke and text
    ///   - height: heigh of button
    ///   - radius: corner radius of button
    ///   
    static func outline(color: Color, height: CGFloat = 42, radius: CGFloat = 24) -> OutlineButtonStyle {
        OutlineButtonStyle(color: color, height: height, radius: radius)
    }
}
