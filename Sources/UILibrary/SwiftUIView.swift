//
//  SwiftUIView.swift
//
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI
import Combine

struct Test: Hashable {
    var name: String
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
    
    @State var items = [Test(name: "Test"), Test(name: "Test 2")]
    
    var body: some View {
        RefreshableScrollView(onRefresh: {
            items[0].name = "Refresed data \(Date())"
        }) {
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
    @State private var name = ""
    @State private var email: String? = nil
    @State private var number: Double? = nil
    
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
                    
                    Button("Button solid disabled", action: openRefreshableView)
                        .buttonStyle(.solid)
                        .disabled(true)
                    
                    Button("Button outline disabled", action: openRefreshableView)
                        .buttonStyle(.outline)
                        .disabled(true)
                    
                    Button("Show page loading", action: showPageLoading)
                        .buttonStyle(.outline)
                        .pageLoading(when: $showLoading, text: "Sending")
                }
            }
            
            Section(header: Text("Text Field")) {
                LabelTextField("Name", text: $name)
                    .placeholder("John Doe")
                    .setMaxLength(40)
                    .capitalization(.words)
                
                LabelTextField("Email", text: $email.ifNil(replaceWith: ""))
                    .required(true)
                    .placeholder("user@example.com")
                    .setMaxLength(40)
                    .addValidation(email.isNilOrBlank, message: "Email cannot be blank or empty")
                    .addValidation(email.ifNil(replaceWith: "").count < 10, message: "Email must more than 10 characters")
                
                NumericTextField("Quantity", value: $number)
                
                Text("VALUE: \(number ?? 0.0)")
                
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
        }
    }
}



