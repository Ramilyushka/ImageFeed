//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Наиль on 13/09/23.
//

import Foundation
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private let profileInfoService = ProfileInfoService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    private var alertPresenter = AlertPresenter()
    
    @IBOutlet private weak var splashImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        
        createSplashImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }

    private func checkAuthStatus(){
        if let token = oAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
            imagesListService.fetchPhotosNextPage()
        } else {
            showAuthViewController()
        }
    }
    
    private func showAuthViewController(){
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewController")
        guard let authViewController = authViewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
    
    private func showNetworkError() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { _ in
                let _ = OAuth2TokenStorage().removeToken()
                self.showAuthViewController()
            })
        alertPresenter.showAlert(alertModel: alertModel)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code: code)
        alertPresenter.delegate = vc
    }
    
    private func fetchOAuthToken(code: String) {
        
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                self.imagesListService.fetchPhotosNextPage()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("----ERROR fetchAuthToken----")
                print(error)
                self.showNetworkError()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileInfoService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImage(username: profile.userName, token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("----ERROR fetchProfile----")
                print(error)
                self.showNetworkError()
            }
        }
    }
    
    private func fetchProfileImage(username: String, token: String) {
        profileImageService.fetchProfileImageURL(username: username, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print("----ERROR fetchProfileImageURL----")
                print(error)
                self.showNetworkError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension SplashViewController {
    
    private func createSplashImageView() {
        
        view.backgroundColor = .ypBlack
        
        let image = UIImage(named: "launch_screen") ?? UIImage()
        
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .ypBlack
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 77).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        splashImageView = imageView
    }
}
