//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Наиль on 27/08/23.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: "Auth token")
        }
        set {
            guard let token = newValue else { return }
            keychainWrapper.set(token, forKey: "Auth token")
        }
    }
    
    func removeToken() -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: "Auth token")
    }
}
