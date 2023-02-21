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
    
    // popup
    @State private var showPopup = false
    @State private var itemPopup: String? = nil
    
    // loading
    @State private var showLoading = false
    
    // text
    @State private var text = ""
    
    let items = [Test(name: "Test"), Test(name: "Test 2")]
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Button("Popup use bool", action: openPopupBoolean)
                    .buttonStyle(.solid)
                    .buttonLoading(showPopup)
                    .popup(isPresented: $showPopup) {
                        MyView(text: "Popup use bool")
                    }
                
                Button("Popup use identifiable", action: openPopupItem)
                    .buttonStyle(.outline)
                    .buttonLoading(showPopup)
                    .popup(item: $itemPopup) {
                        MyView(text: $0)
                    }
                
                Button("Show page loading", action: showPageLoading)
                    .buttonStyle(.solid)
                    .pageLoading(when: $showLoading, text: "Sending")
                
                LabelTextField("Email", text: $text)
                    .required(true)
                    .placeholder("user@example.com")
                    .setMaxLength(10)
                    .setMaxLength(10)
            }
            
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openPopupBoolean() {
        self.showPopup.toggle()
    }
    
    private func openPopupItem() {
        self.itemPopup = "Popup use identifiable"
    }
    
    private func showPageLoading() {
        self.showLoading.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showLoading.toggle()
        }
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIView()
//                .preferredColorScheme(.dark)
        }
    }
}
