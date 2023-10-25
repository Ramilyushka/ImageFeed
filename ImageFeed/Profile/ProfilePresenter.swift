//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Наиль on 23/10/23.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func createLogoutAlert() -> UIAlertController
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    let profileInfoService: ProfileInfoServiceProtocol
    let profileImageService: ProfileImageServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    
    let imagesListService = ImagesListService.shared
    
    init() {
        self.profileInfoService = ProfileInfoService.shared
        self.profileImageService = ProfileImageService.shared
    }
    
    init(profileInfoService: ProfileInfoServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileInfoService = profileInfoService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        serviceObserver()
        getProfile()
        getURLAvatar()
    }
    
    private func serviceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.getURLAvatar()
            })
    }
    
    private func getProfile() {
        guard let profile = profileInfoService.profile else {
            return
        }
        view?.updateProfileDetails(profile: profile)
    }
    
    private func getURLAvatar() {
        guard
            let avatarImageURL = profileImageService.avatarImageURL,
            let url = URL(string: avatarImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
    
    func createLogoutAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(
            title: "Да",
            style: .default,
            handler: {_ in
                self.cleanDataAndSwitchToSplash()
            })
        actionCancel.accessibilityIdentifier = "Yes"
        alert.addAction(actionCancel)
        
        let actionContinue = UIAlertAction(
            title: "Нет",
            style: .default,
            handler: nil)
        alert.addAction(actionContinue)
        
        return alert
    }
    
    private func cleanDataAndSwitchToSplash() {
        profileInfoService.cleanData()
        switchToSplashViewController()
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
