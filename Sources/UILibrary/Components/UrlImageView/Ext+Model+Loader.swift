//
//  Ext+Model+Loader.swift
//
//
//  Created by Cadis on 15/02/23.
//

#if os(iOS)
import SwiftUI
import Combine

class ImageModel : ObservableObject {
    @Published var url: URL? = nil
    @Published var error: String? = nil
    @Published var placeholder: String? = nil
    @Published var aspecRatio: ContentMode = .fill
}

class ImageLoader: ObservableObject {

    @Published var image: UIImage?
    @Published private(set) var isLoading = false

    private var cancellable: AnyCancellable?
    private static let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()

    func load(_ url: URL?) {
        guard let url, !isLoading, image == nil else { return }

        cancellable?.cancel()

        if let image = ImageLoader.cache.object(forKey: url as NSURL) {
            self.image = image
            return
        }

        isLoading = true
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }) { image in
                if let image = image {
                    ImageLoader.cache.setObject(image, forKey: url as NSURL)
                    self.image = image
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
    }
}

public extension UrlImageView {

    /// Sets aspect ratio image
    func modeRatio(_ mode: ContentMode) -> Self {
        imageModel.aspecRatio = mode
        return self
    }

    /// Sets placeholder image
    func placeholder(assetName: String) -> Self {
        imageModel.placeholder = assetName
        imageModel.error = assetName
        return self
    }

    /// Sets error image
    func errorImage(assetName: String) -> Self {
        imageModel.error = assetName
        return self
    }
}
#endif

