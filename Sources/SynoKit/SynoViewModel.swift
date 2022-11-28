//
//  SynoViewModel.swift
//  SynoKit
//
//  Created by EdgardVS on 28/11/22.
//

import Foundation
import UIKit

public class ViewModel: ObservableObject {
    
    var imageCache  = ImageCache.getImageCache()
    @Published var imageC: UIImage?
    @Published var loading: Bool = true
    //new version with workspace
    init(photoPath: String, domainPath: String) {
        if photoPath.contains("jpeg") || photoPath.contains("png") || photoPath.contains("jpg") {
            if loadImageFromCache(path: photoPath) {
                print("usando cache sin llamar al servicio")
                loading = false
                return
            }
            print("nueva imagen llamando al servicio")
            getImage(path: photoPath, domainPath: domainPath)
        } else {
            imageC = UIImage(named: "trofeo")
            loading = false
        }
    }
        
    func getImage(path: String, domainPath: String) {
        Service.shared.download(path: path, domainPath: domainPath) { response , loading  in
            guard let loadedImage = UIImage(data: response) else {
                return
            }
            self.imageC = loadedImage
            self.loading = false
            self.imageCache.set(forKey: path, image: loadedImage)
        }
            
    }
    
    func loadImageFromCache(path: String) -> Bool {
            guard let cacheImage = imageCache.get(forKey: path) else {
                return false
            }
            imageC = cacheImage
            return true
        }
}
