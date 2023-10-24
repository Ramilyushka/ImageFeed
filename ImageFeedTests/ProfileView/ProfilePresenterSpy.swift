//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Наиль on 23/10/23.
//

import Foundation
import UIKit
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var logOutCalled: Bool = false
     
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func createLogoutAlert() -> UIAlertController {
        logOutCalled = true
        let alertFake = UIAlertController(title: "test", message: "test", preferredStyle: .alert)
        return alertFake
    }
}
