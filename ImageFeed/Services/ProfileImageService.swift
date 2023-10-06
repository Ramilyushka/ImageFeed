//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Наиль on 04/10/23.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    private func profileImageRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchProfileImageURL(username: String, token: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard avatarURL == nil else { return }
        
        currentTask?.cancel() //отменяем первую таску, если был повторный вызов
        
        var request = profileImageRequest(username: username)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<UserResult, Error>)  in
            
            self?.currentTask = nil
            
            guard let self = self else  {return }
            
            switch result {
            case .success(let userResult):
                
                let avatarURL = userResult.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(""))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
