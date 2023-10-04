//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Наиль on 03/10/23.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let userName: String
    let fullName: String
    let bio: String?
    var loginName: String { return "@" + userName }
}

extension Profile {
    init(result profileResult: ProfileResult){
        self.init(
            userName: profileResult.userName,
            fullName: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")",
            bio: profileResult.bio)
    }
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        currentTask?.cancel() //отменяем первую таску, если был повторный вызов
        
        var request = profileRequest(token: token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask =  object(for: request) {[weak self] result in
            
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

extension ProfileService {
    
    private func profileRequest(token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {

        let decoder = JSONDecoder()

        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
}
