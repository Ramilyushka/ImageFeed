//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Наиль on 23/10/23.
//

import Foundation
import UIKit
import WebKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getProfile()
    func getURLAvatar()
    func clearData()
    func showSplashViewController()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol?) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    getURLAvatar()
                }
        
        getProfile()
        getURLAvatar()
    }
    
    func getProfile() {
        guard let profile = ProfileInfoService.shared.profile else {
            return
        }
        print(profile)
        view?.updateProfileDetails(profile: profile)
    }
    
    func getURLAvatar() {
        guard
            let avatarImageURL = ProfileImageService.shared.avatarImageURL,
            let url = URL(string: avatarImageURL)
        else { return }
        print(url)
        view?.updateAvatar(url: url)
    }
    
    func clearData() {
        clearTokenStorage()
        clearCookies()
    }
    
    private func clearTokenStorage() {
        let _ = OAuth2TokenStorage.shared.removeToken()
    }
    
    private func clearCookies() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
    
    func showSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
