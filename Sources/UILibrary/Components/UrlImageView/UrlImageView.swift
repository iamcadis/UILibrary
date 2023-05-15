//
//  UrlImageView.swift
//  
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

private struct ClickShape: Shape {
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
                if let defaultImage = imageModel.defaultImage {
                    imageView(uiImage: defaultImage, size: geo.size)
                } else {
                    if imageLoader.isLoading {
                        if let placeholder = imageModel.placeholder {
                            imageView(name: placeholder, size: geo.size)
                        } else {
                            Text("Loading...")
                        }
                    } else {
                        if let resultImage = imageLoader.image {
                            imageView(uiImage: resultImage, size: geo.size)
                        } else {
                            if let error = imageModel.error {
                                imageView(name: error, size: geo.size)
                            } else {
                                Text("No Image")
                            }
                        }
                    }
                }
                
                if imageLoader.isVideo {
                    Image(systemName: "play.circle")
                        .font(.system(size: 28))
                        .foregroundColor(Color(UIColor.systemBackground))
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
            .contentShape(ClickShape(height: size.height))
    }
    
    private func imageView(uiImage: UIImage, size: CGSize) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: imageModel.aspecRatio)
            .frame(maxWidth: size.width, maxHeight: size.height)
            .clipped()
            .contentShape(ClickShape(height: size.height))
    }
    
    private func loadImage(_ url: URL?) {
        guard let url else { return }
        
        if imageLoader.image == nil, !imageLoader.isLoading {
            self.imageLoader.load(url)
        }
    }
}

public extension UrlImageView {
    
    /// Set aspect ratio image
    func modeRatio(_ mode: ContentMode) -> Self {
        imageModel.aspecRatio = mode
        return self
    }
    
    /// Set placeholder image using asset name
    func placeholder(assetName: String) -> Self {
        imageModel.placeholder = assetName
        imageModel.error = assetName
        return self
    }
    
    /// Set error image using asset name
    func errorImage(assetName: String) -> Self {
        imageModel.error = assetName
        return self
    }
    
    /// Set image using UIImage
    func defaultImage(image: UIImage?) -> Self {
        imageModel.defaultImage = image
        return self
    }
}
