//
//  Service.swift
//  SynoKit
//
//  Created by EdgardVS on 28/11/22.
//

import Foundation
import Alamofire

public struct Service {
    static let shared = Service()
    
    func login(domainPath: String, user: String, password: String, completion: @escaping (LoginResponse) ->()) {
        
        let fullUrl = "\(domainPath)/webapi/auth.cgi?api=SYNO.API.Auth&version=3&method=login&account=\(user)&passwd=\(password)&session=FileStation&format=cookie"
        
        AF.request(fullUrl, method: .get).responseDecodable(of: LoginResponse.self) { response in
            if let data = response.value {
                completion(data)
            }
        }
    }
            
    func download(path: String, domainPath: String, completion: @escaping (Data, Bool) ->()) {
        
        let fullUrl = "\(domainPath)/webapi/entry.cgi?api=SYNO.FileStation.Download&version=2&method=download&path=\(path)&mode=%22open%22"
        
        AF.download(fullUrl,method: .get , headers: nil).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data, false)
            case .failure(let error):
                completion(Data(), false)
                print(error)
                print(error.localizedDescription)
            }
        }
    }
       
    
}
