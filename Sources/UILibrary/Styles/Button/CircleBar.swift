//
//  CircleBar.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

struct CircleBar: View {
    let background: Color
    let foreground: Color
    
    @State private var isLoading = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(foreground, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .rotationEffect(.degrees(isLoading ? 360 : 0))
            .animation(.default.repeatForever(autoreverses: false), value: isLoading)
            .onAppear {
                self.isLoading = true
            }
    }
}

struct CircleBar_Previews: PreviewProvider {
    static var previews: some View {
        CircleBar(background: .accentColor, foreground: .accentColor)
    }
}



