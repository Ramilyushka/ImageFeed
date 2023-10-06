//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Наиль on 03/10/23.
//

import Foundation

final class ProfileInfoService {
    
    static let shared = ProfileInfoService()
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?

    private (set) var profile: Profile?
    
    private func profileRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard profile == nil else { return }
        
        currentTask?.cancel() //отменяем первую таску, если был повторный вызов
        
        var request = profileRequest()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<ProfileResult, Error>)  in
            self?.currentTask = nil
            
            guard let self = self else  {return }
            
            switch result {
            case .success(let profileResult):
                
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
