//
//  Constants.swift
//  ImageFeed
//
//  Created by Наиль on 28/07/23.
//

import Foundation

enum Constants {
    
//    static let accessKey = "WdVo_zQdgh5P0B5aolxwPrpVbMxWfRBJaYdup--Y8UY"
//    static let secretKey = "Ja2fOeQtq8JE58AcV_EPNgN0qE-JgLUNZuET6tEJElI"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessKey = "23hvEULZRBmPJ9wJ2YYhwkZZHV1FK45IxuXZ5EUt5B0"
    static let secretKey = "HVeaOV4fglH3tMSAp0e4-Q40TaXdduOyflBLW26nffs"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
//    static let accessKey = "zCjCSr8jtSOUzOe1wWE7rO2z-9jBhpF9dkQoRiNsugM"
//    static let secretKey = "62iefqS86uTN7dN18YrvJL25U3EfMt0tzwkcbJI9mzo"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultApiBaseURL: URL = URL(string: "https://api.unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultApiBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
