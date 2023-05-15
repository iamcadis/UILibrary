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

struct ExampleRefreshableView: View {
    @Environment (\.dismiss) var dismiss
    
    let items = [Test(name: "Test"), Test(name: "Test 2")]
    
    var body: some View {
        RefreshableScrollView {
            VStack {
                ForEach(items, id: \.self) { item in
                    Text(item.name)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        }
        .navigationTitle("Testing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: dismiss) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
    }
}

struct SwiftUIView: View {
    
    // popup
    @State private var showPopup = false
    @State private var showRefreshableview = false
    @State private var itemPopup: String? = nil
    
    // loading
    @State private var showLoading = false
    
    // text
    @State private var name: String? = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section(header: Text("Button")) {
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
                    
                    Button("Show Refreshableview", action: openRefreshableView)
                        .buttonStyle(.solid)
                        .fullScreenCover(isPresented: $showRefreshableview) {
                            NavigationView {
                                ExampleRefreshableView()
                            }
                        }
                    
                    Button("Show page loading", action: showPageLoading)
                        .buttonStyle(.outline)
                        .pageLoading(when: $showLoading, text: "Sending")
                }
            }
            
            Section(header: Text("Text Field")) {
                LabelTextField("Nama", text: $name.wrapToRequired)
                    .placeholder("John Doe")
                    .setMaxLength(40)
                    .capitalization(.words)
                
                LabelTextField("Email", text: $email)
                    .required(true)
                    .placeholder("user@example.com")
                    .setMaxLength(40)
                    .requiredMessage("Testing ganti required message")
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
    
    private func openRefreshableView() {
        self.showRefreshableview.toggle()
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

