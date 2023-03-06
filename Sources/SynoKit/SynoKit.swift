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
    
    
    public struct SynoImage<Content: View>: View {
        
        @ObservedObject var vm: ViewModel
        @State var path: String
        @State var domainPath: String
        @State var isIcon : Bool
        @ViewBuilder var placeHolder: Content
        
        public init(user: String, password: String, path: String, domainPath: String, isIcon: Bool, @ViewBuilder placeHolder: () -> Content) {
            self._path = State(initialValue: path)
            self._domainPath = State(initialValue: domainPath)
            self._vm = ObservedObject(wrappedValue: ViewModel(photoPath: path, domainPath: domainPath))
            self._isIcon = State(initialValue: isIcon)
            self.placeHolder = placeHolder()
        }
        
        public var body: some View {
            VStack {
                if vm.imageC != nil{
                    
                    Image(uiImage: vm.imageC!)
                        .resizable()
                        .renderingMode( isIcon ? .template : .original)
                    
                }else{
                    placeHolder
                }
            }.onAppear{
                if vm.imageC == nil {
                    vm.setSynoImage(photoPath: path, domainPath: domainPath)
                }
            }.onDisappear{
                vm.imageC = nil
            }
        }
    }
}
