//
//  ProfilePresenterTests.swift
//  ImageFeedTests
//
//  Created by Наиль on 24/10/23.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterTests: XCTestCase {
    
    var profileInfoServiceStub = ProfileInfoServiceStub()
    var profileImageServiceStub = ProfileImageServiceStub()
    var presenter: ProfilePresenterProtocol?
    var viewController = ProfileViewControllerSpy()
    var profileFake = Profile.standart
    
    override func setUpWithError() throws {
        //given
        profileInfoServiceStub.profile = profileFake
        profileImageServiceStub.avatarImageURL = "https://images.unsplash.com/profile-1692802319608-62cbbad5a63c?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32"
        
        presenter = ProfilePresenter(profileInfoService: profileInfoServiceStub, profileImageService: profileImageServiceStub)
        
        presenter?.view = viewController
        viewController.presenter = presenter
    }
    
    func testCallsGetProfileAndURLAvatar() {
        //when
        presenter?.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled) //behaviour verification
        XCTAssertTrue(viewController.updateAvatarCalled) //behaviour verification
    }
    
    func testUpdateProfileDetails() {
        //when
        viewController.updateProfileDetails(profile: profileFake)
        
        //then
        XCTAssertEqual(viewController.fullNameLabelFake.text, profileFake.fullName)
        XCTAssertEqual(viewController.loginNameLabelFake.text, profileFake.loginName)
        XCTAssertEqual(viewController.bioDescriptionLabelFake.text,profileFake.bio)
    }
}
