//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Наиль on 04/10/23.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    
    private (set) var avatarImageURL: String?
    
    private func profileImageRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchProfileImageURL(username: String, token: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        var request = profileImageRequest(username: username)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<ProfileImageResult, Error>)  in
            
            self?.currentTask = nil
            
            guard let self = self else  {return }
            
            switch result {
            case .success(let profileImage):
                
                let avatarURL = profileImage.profileImageURL.medium
                self.avatarImageURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL])
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
