//
//  SwiftUIView.swift
//  
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var loading = false
    
    var body: some View {
        Button("Label", action: {
            loading.toggle()
        })
            .buttonStyle(.solid(background: .red, foreground: .white))
            .cornerRadius(24)
            .padding()
            .isLoading(loading)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
