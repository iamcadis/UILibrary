//
//  RefreshableScrollView.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

private enum RefreshState {
    case waiting, primed, loading
}

public struct RefreshableScrollView<Content: View>: View {
    private let showsIndicators: Bool
    private let content: Content
    private let treshold: CGFloat = 50
    private var actionRefresh: (() -> Void)? = nil
    
    @State private var state: RefreshState = .waiting
    @State private var offset: CGFloat = .zero
    @State private var startOffset: CGFloat = .zero
    
    public init(showsIndicators: Bool = false, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.actionRefresh = action
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                ZStack(alignment: .top) {
                    content
                        .allowsHitTesting(state != .loading)
                        .animation(.linear, value: state)
                        .alignmentGuide(.top, computeValue: { _ in
                            state == .loading ? -treshold : 0
                        })
                    if state == .loading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(.circular)
                            .animation(.linear, value: state)
                            .padding(.top, 8)
                    }
                }
                .background(
                    GeometryReader { reader -> Color in
                        calculateComputeSize(reader: reader)
                        return Color.clear
                    }
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func calculateComputeSize(reader: GeometryProxy) {
        
        if startOffset == 0 {
            startOffset = reader.frame(in: .global).minY
        }
        
        offset = reader.frame(in: .global).minY
        
        // If the user pulled down below the threshold, prime the view
        if offset - startOffset > treshold && state == .waiting {
            state = .primed
        } else if offset == startOffset && state == .primed {
            state = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // once refreshing is done, smoothly move the loading view
                // back to the offset position
                withAnimation {
                    self.state = .waiting
                }
                self.actionRefresh?()
            }
        }
    }
    
}
