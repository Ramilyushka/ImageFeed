//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Наиль on 24/10/23.
//

import Foundation
@testable import ImageFeed

final class ProfileInfoServiceStub: ProfileInfoServiceProtocol {
    var profile: ImageFeed.Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {
        //code
    }
    func cleanData() {
        //<#code#>
    }
}

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarImageURL: String?
    
    func fetchProfileImageURL(username: String, token: String, completion: @escaping (Result<String, Error>) -> Void) {
       // <#code#>
    }
}
