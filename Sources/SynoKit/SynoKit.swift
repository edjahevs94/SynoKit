import SwiftUI

public struct SynoKit {
    
    public init() {
        
    }
    
    public func getSynoImageFromCache(path: String) -> UIImage? {
        var imageCache  = ImageCache.getImageCache()
        guard let cacheImage = imageCache.get(forKey: path) else {
            return nil
        }
        return cacheImage
    }
    
    public func getCredentials(domainPath: String, user: String, password: String){
        Service.shared.login(domainPath: domainPath, user: user, password: password) { response in
            
            let did = response.data.did
            let sid = response.data.sid
            UserDefaults.standard.set(did, forKey: "did")
            UserDefaults.standard.set(sid, forKey: "sid")
            
        }
    }
    
    
    public struct SynoImage: View {
        
        @ObservedObject var vm: ViewModel
        @State var placeHolder: UIImage
        @State var path: String
        @State var domainPath: String
        
        public init(path: String, domainPath: String, placeHolder: UIImage) {
            self._path = State(initialValue: path)
            self._domainPath = State(initialValue: domainPath)
            self._placeHolder = State(initialValue: placeHolder)
            self._vm = ObservedObject(wrappedValue: ViewModel(photoPath: path, domainPath: domainPath))
        }
        
        public var body: some View {
            if !(vm.loading) {
                Image(uiImage: vm.imageC ?? placeHolder)
                .resizable()
            } else {
                ProgressView()
            }
        }
    }
}
