//
//  UrlImageView.swift
//  
//
//  Created by Cadis on 15/02/23.
//

#if os(iOS)
import SwiftUI

private struct TapShape: Shape {
    var height: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: height))
    }
}

public struct UrlImageView: View {
    
    @ObservedObject var imageModel: ImageModel
    @ObservedObject var imageLoader: ImageLoader
    
    public init(url: String?) {
        let imageModel = ImageModel()
        imageModel.url = URL(string: url ?? "")
        _imageModel = ObservedObject(wrappedValue: imageModel)
        _imageModel.update()
        
        let imageLoader = ImageLoader()
        _imageLoader = ObservedObject(wrappedValue: imageLoader)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if let uiImage = imageLoader.image, !imageLoader.isLoading {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: imageModel.aspecRatio)
                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                        .clipped()
                        .contentShape(TapShape(height: geo.size.height))
                } else {
                    Color.primary.opacity(0.05)
                    if let error = imageModel.error, !imageLoader.isLoading {
                        imageView(name: error, size: geo.size)
                    } else {
                        if let placeholder = imageModel.placeholder {
                            imageView(name: placeholder, size: geo.size)
                        } else {
                            Text(imageLoader.isLoading ? "Loading..." : "No Image")
                        }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onReceive(imageModel.$url, perform: loadImage)
    }
    
    private func imageView(name: String, size: CGSize) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: size.width, maxHeight: size.height)
            .padding(size.height / 10)
            .contentShape(TapShape(height: size.height))
    }
    
    private func loadImage(_ url: URL?) {
        guard let url else { return }
        
        if imageLoader.image == nil, !imageLoader.isLoading {
            self.imageLoader.load(url)
        }
    }
}
#endif
