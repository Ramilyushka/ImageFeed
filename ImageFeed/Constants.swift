//
//  Constants.swift
//  ImageFeed
//
//  Created by Наиль on 28/07/23.
//

import Foundation

enum Constants {
    
    static let accessKey = "WdVo_zQdgh5P0B5aolxwPrpVbMxWfRBJaYdup--Y8UY"
    static let secretKey = "Ja2fOeQtq8JE58AcV_EPNgN0qE-JgLUNZuET6tEJElI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultApiBaseURL: URL = URL(string: "https://api.unsplash.com")!
}
