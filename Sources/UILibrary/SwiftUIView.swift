//
//  SwiftUIView.swift
//  
//
//  Created by Cadis on 16/02/23.
//

#if os(iOS)
import SwiftUI
import Combine

struct MyView: View {
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Popup")
                .onTapGesture(perform: dismiss)
        }
        .frame(width: 300, height: 300)
    }
}

struct SwiftUIView: View {
    @State private var showPopup = false
    @State private var showPopup2 = false
    
    init() {
        if #available(iOS 15.0, *) {
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Button("Show Popup 1", action: {
                    showPopup.toggle()
                })
                .popup(isPresented: $showPopup) {
                    MyView()
                }
            }
            .navigationTitle("LAPET")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
#endif
