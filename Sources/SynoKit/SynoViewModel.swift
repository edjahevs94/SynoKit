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
    init(photoPath: String, domainPath: String) {
       
        setSynoImage(photoPath: photoPath, domainPath: domainPath)
    }
    
    func setSynoImage(photoPath: String, domainPath: String){
        if photoPath.contains("jpeg") || photoPath.contains("png") || photoPath.contains("jpg") {
            if loadImageFromCache(path: photoPath) {
                //print("usando cache sin llamar al servicio")
                return
            }
            //print("nueva imagen llamando al servicio")
            getImage(path: photoPath, domainPath: domainPath)
        }
            //print("Image format is incorrect: Only jpeg, jpg or png formats are allowed.")
       
    }
    
    func loginSynology(domainPath: String, user: String, password: String) {
        
        Service.shared.login(domainPath: domainPath, user: user, password: password) { response in
                let did = response.data.did
                let sid = response.data.sid
            
                UserDefaults.standard.set(did, forKey: "did")
                UserDefaults.standard.set(sid, forKey: "sid")
          
            }
           
    }
        
    func getImage(path: String, domainPath: String) {
        Service.shared.download(path: path, domainPath: domainPath) { response , loading  in
            guard let loadedImage = UIImage(data: response) else {
             
                return
            }
            self.imageC = loadedImage.aspectFittedToHeight(newHeight: 200)
          
            self.imageCache.set(forKey: path, image: loadedImage.aspectFittedToHeight(newHeight: 200))
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
