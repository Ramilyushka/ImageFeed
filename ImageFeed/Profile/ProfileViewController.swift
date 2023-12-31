//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Наиль on 12/07/23.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func updateAvatar(url: URL)
    func showLogOutAlert()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var bioDescriptionLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        
        if presenter == nil {
            presenter = ProfilePresenter(
                profileInfoService: ProfileInfoService.shared,
                profileImageService: ProfileImageService.shared)
        }
        presenter?.viewDidLoad()
    }
    
    func updateProfileDetails(profile: Profile) {
        fullNameLabel.text = profile.fullName
        loginNameLabel.text = profile.loginName
        bioDescriptionLabel.text = profile.bio
    }
    
    func updateAvatar(url: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "stub_profile"))
    }
    
    func showLogOutAlert() {
        if let alert = presenter?.createLogoutAlert() {
            present(alert, animated: true)
        }
    }
    
    @IBAction private func didTapLogoutButton() {
        showLogOutAlert()
    }
}

extension ProfileViewController {
    
    private func createView(){
        
        view.backgroundColor = .ypBlack
        
        createAvatarImageView()
        createLogoutButton()
        createFullNameLabel()
        createLoginNameLabel()
        createBioDescriptionLabel()
    }
    
    private func createAvatarImageView() {
        
        let image = UIImage(named: "stub") ?? UIImage()
        
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.backgroundColor = .ypBlack
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        avatarImageView = imageView
    }
    
    private func createLogoutButton() {
        
        let button = UIButton.systemButton(
            with: UIImage(named: "logout") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton))
        
        button.accessibilityIdentifier = "logout button"
        button.tintColor = .ypRed
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        
        self.logoutButton = button
    }
    
    private func createFullNameLabel() {
        let label = UILabel()
        label.accessibilityIdentifier = "Name Lastname"
        label.text = "Екатерина Новикова"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .ypWhite
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        self.fullNameLabel = label
    }
    
    private func createLoginNameLabel() {
        let label = UILabel()
        label.accessibilityIdentifier = "@username"
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor).isActive = true
        
        self.loginNameLabel = label
    }
    
    private func createBioDescriptionLabel() {
        
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor).isActive = true
        
        self.bioDescriptionLabel = label
    }
}
