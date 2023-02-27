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
        @State var user: String
        @State var password: String
        @State var isIcon : Bool
        
        public init(user: String, password: String, path: String, domainPath: String, placeHolder: UIImage, isIcon: Bool) {
            self._path = State(initialValue: path)
            self._domainPath = State(initialValue: domainPath)
            self._placeHolder = State(initialValue: placeHolder)
            self._user = State(initialValue: user)
            self._password = State(initialValue: password)
            self._vm = ObservedObject(wrappedValue: ViewModel(user: user, password: password, photoPath: path, domainPath: domainPath))
            self._isIcon = State(initialValue: isIcon)
        }
        
        public var body: some View {
            VStack {
                if !(vm.loading) {
                    if isIcon{
                        Image(uiImage: vm.imageC ?? placeHolder)
                            .resizable()
                            .renderingMode(.template)
                    }else{
                        
                        Image(uiImage: vm.imageC ?? placeHolder)
                            .resizable()
                    }
                } else {
                    ProgressView()
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
