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
    
    static var standart: Profile {
        Profile(
            userName: "Ivanov",
            fullName: "Ivan Ivanov",
            bio: "I am Ivan")
    }
}
