//
//  Extensions.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

public extension View {
    func isLoading(_ show: Bool) -> some View {
        environment(\.isLoading, show)
    }
}

public extension ButtonStyle where Self == SolidButtonStyle {
    
    static var solid: SolidButtonStyle {
        SolidButtonStyle(background: .accentColor, foreground: .white, height: 42)
    }
    
    static func solid(background: Color, foreground: Color, height: CGFloat = 42) -> SolidButtonStyle {
        SolidButtonStyle(background: background, foreground: foreground, height: 42)
    }
}


