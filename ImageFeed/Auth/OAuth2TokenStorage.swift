//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Наиль on 27/08/23.
//

import Foundation

class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            let bearerToken = userDefaults.string(forKey: "token") ?? ""
            return bearerToken
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
