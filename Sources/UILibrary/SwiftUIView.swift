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
        .frame(height: 300)
        .frame(maxWidth: .infinity)
    }
}

struct SwiftUIView: View {
    @State private var showPopup = false
    @State private var lapet: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Button("Popup is presented", action: {
                    showPopup.toggle()
                })
                .buttonStyle(.solid)
                .padding(.horizontal)
                .popup(isPresented: $showPopup) {
                    MyView(text: "Popup is presented")
                }
                
                Button("Popup selected item", action: {
                    lapet = "Popup selected item"
                })
                .buttonStyle(.outline)
                .padding(.horizontal)
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
    }
}
#endif





