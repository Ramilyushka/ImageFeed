//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Наиль on 23/10/23.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    var fullNameLabelFake = UILabel()
    var loginNameLabelFake = UILabel()
    var bioDescriptionLabelFake =  UILabel()
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
        fullNameLabelFake.text = profile.fullName
        loginNameLabelFake.text = profile.loginName
        bioDescriptionLabelFake.text = profile.bio
    }
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
    
    func showLogOutAlert() {
        //<#code#>
    }
}
