//
//  CircleBar.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

struct CircleBar: View {
    let color: Color
    
    @State private var isLoading = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .rotationEffect(.degrees(isLoading ? 360 : 0))
            .animation(.default.repeatForever(autoreverses: false), value: isLoading)
            .background(Color.clear)
            .onAppear {
                self.isLoading = true
            }
    }
}
