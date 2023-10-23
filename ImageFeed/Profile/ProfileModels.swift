//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Наиль on 04/10/23.
//

public struct Profile {
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
