//
//  NoBackground.swift
//  
//
//  Created by Cadis on 17/02/23.
//

import SwiftUI

public struct NoBackground: UIViewRepresentable {
        
    public func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
    
    private class BackgroundRemovalView: UIView {
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
        
    }
    
}
