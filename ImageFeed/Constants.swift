//
//  Constants.swift
//  ImageFeed
//
//  Created by Наиль on 28/07/23.
//

import Foundation

enum Constants {
    
    static let accessKey = "zCjCSr8jtSOUzOe1wWE7rO2z-9jBhpF9dkQoRiNsugM"
    static let secretKey = "62iefqS86uTN7dN18YrvJL25U3EfMt0tzwkcbJI9mzo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultApiBaseURL: URL = URL(string: "https://api.unsplash.com")!
}
