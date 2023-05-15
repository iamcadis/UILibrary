//
//  Ext+Model+Loader.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI
import Combine
import AVKit

class ImageModel : ObservableObject {
    @Published var url: URL? = nil
    @Published var error: String? = nil
    @Published var placeholder: String? = nil
    @Published var aspecRatio: ContentMode = .fill
    @Published var defaultImage: UIImage? = nil
}

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isVideo = false
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
        
        self.isVideo = url.isVideo
        
        cancellable?.cancel()
        
        if let image = ImageLoader.cache.object(forKey: url as NSURL) {
            self.image = image
            return
        }
        
        self.isLoading = true
        
        if isVideo {
            AVAsset(url: url).generateThumbnail { image in
                self.setImageAndCache(url: url, uiImage: image)
            }
        } else {
            self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }) { image in
                    self.setImageAndCache(url: url, uiImage: image)
                }
        }
    }
    
    private func setImageAndCache(url: URL, uiImage: UIImage?) {
        if let image = uiImage {
            ImageLoader.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = image
                self.isLoading = false
            }
        }
    }
    
}

extension URL {
    
    var isVideo: Bool {
        let mimeType = UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
        return UTType(mimeType: mimeType)?.conforms(to: .audiovisualContent) ?? false
    }
    
}

extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            
            imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
                
                guard let image else { return completion(nil) }
                
                let uiImage = UIImage(cgImage: image)
                
                if self.tracks.count > 0 {
                    let track = self.tracks[0]
                    let size = track.naturalSize
                    var rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
                    rect = rect.applying(track.preferredTransform)
                    
                    if rect.size.height > rect.size.width {
                        completion(uiImage.rotate(radians: .pi / 2))
                    } else {
                        completion(uiImage)
                    }
                    
                    return
                }
                
                return completion(nil)

            }
        }
    }
}
