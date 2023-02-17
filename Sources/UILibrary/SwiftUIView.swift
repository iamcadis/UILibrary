//
//  SwiftUIView.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI
import Combine

struct Test: Hashable {
    let name: String
}

struct MyView: View {
    @Environment (\.dismiss) var dismiss
    
    var text: String
    
    var body: some View {
        VStack(spacing: 16) {
            UrlImageView(url: "https://www.logodesign.net/images/home-page-logo-03.png")
            Text(text)
                .padding(.bottom)
                .onTapGesture(perform: dismiss)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
    }
}

struct SwiftUIView: View {
    @State private var showPopup = false
    @State private var showLoading = false
    @State private var lapet: String? = nil
    @State private var selection = Test(name: "Test")
    
    let items = [Test(name: "Test"), Test(name: "Test 2")]
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Button("Popup use bool", action: {
                    showPopup.toggle()
                })
                .buttonStyle(.solid)
                .padding(.horizontal)
                .loading(showPopup)
                .popup(isPresented: $showPopup) {
                    MyView(text: "Popup use bool")
                }
                
                Button("Popup use identifiable", action: {
                    lapet = "Popup use identifiable"
                })
                .buttonStyle(.outline)
                .padding(.horizontal)
                .popup(item: $lapet) {
                    MyView(text: $0)
                }
                
                Button("Show page loading", action: {
                    showLoading.toggle()
                })
                .buttonStyle(.solid)
                .padding(.horizontal)
            }
            
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.inline)
        .showPageLoading(when: $showLoading, text: "Loading")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIView()
        }
    }
}



