//
//  ProfileModelsCodable.swift
//  ImageFeed
//
//  Created by Наиль on 21/10/23.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct ProfileImageURLs: Codable {
    let small: String
    let medium: String
    let large: String
}

struct ProfileImageResult: Codable {
    let profileImageURLs: ProfileImageURLs
    
    private enum CodingKeys: String, CodingKey {
        case profileImageURLs = "profile_image"
    }
}

