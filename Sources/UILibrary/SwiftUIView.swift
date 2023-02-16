//
//  SwiftUIView.swift
//
//
//  Created by Cadis on 16/02/23.
//

#if os(iOS)
import SwiftUI
import Combine

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

struct MyView: View {
    @Environment (\.dismiss) var dismiss
    
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .onTapGesture(perform: dismiss)
        }
        .frame(width: 300, height: 300)
        .preferredColorScheme(.dark)
    }
}

struct SwiftUIView: View {
    @State private var showPopup = false
    @State private var lapet: String? = nil
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
                    MyView(text: "Popup 1")
                }
                
                Button("Show Popup 2", action: {
                    lapet = "ada data"
                })
                .popup(item: $lapet) {
                    MyView(text: $0)
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
            .preferredColorScheme(.dark)
    }
}
#endif





