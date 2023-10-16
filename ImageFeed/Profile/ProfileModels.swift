//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Наиль on 04/10/23.
//

struct Profile {
    let userName: String
    let fullName: String
    let bio: String?
    var loginName: String { return "@" + userName }
}

extension Profile {
    init(result profileResult: ProfileResult){
        self.init(
            userName: profileResult.userName,
            fullName: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")",
            bio: profileResult.bio)
    }
}

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

struct ProfileImageURL: Codable {
    let small: String
    let medium: String
    let large: String
}

struct ProfileImageResult: Codable {
    let profileImageURL: ProfileImageURL
    
    private enum CodingKeys: String, CodingKey {
        case profileImageURL = "profile_image"
    }
}
