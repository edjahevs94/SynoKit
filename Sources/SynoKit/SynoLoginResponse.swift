//
//  SynoLoginResponse.swift
//  SynoKit
//
//  Created by EdgardVS on 28/11/22.
//

import Foundation

struct LoginResponse: Decodable {
    let data: Credentials
    let success: Bool
}

// MARK: - DataClass
struct Credentials: Decodable {
    let did, sid: String
}
