//
//  ImageCache.swift
//  SynoKit
//
//  Created by EdgardVS on 28/11/22.
//

import Foundation
import UIKit

class ImageCache {
    var cache: NSCache<NSString, UIImage> = {
        let imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 30
        imageCache.totalCostLimit = 1024 * 1024 * 50
        //imageCache.totalCostLimit = 1024 * 1024 * 50
        return imageCache
    }()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
