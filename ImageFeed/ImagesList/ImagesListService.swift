//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Наиль on 16/10/23.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func fetchChangeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    
    private var taskNextPhoto: URLSessionTask?
    private var taskChangeLike: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    private var perPage = 10
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        taskNextPhoto?.cancel()
        
        var request = photoRequest()
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        
        taskNextPhoto = urlSession.object(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            
            self?.taskNextPhoto = nil
            
            guard let self = self else  { return }
            
            switch result {
            case .success(let photoResultArray):
                
                for photoResult in photoResultArray {
                    self.photos.append(Photo(result: photoResult))
                }
                lastLoadedPage += 1
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": self.photos])
                
            case .failure(_):
                return
            }
        }
    }
    
    func fetchChangeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        taskChangeLike?.cancel()
        
        var request = likeRequest(photoId, isLike)
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        
        taskChangeLike = urlSession.object(for: request) { (result: Result<OnePhotoResult, Error>) in
            
            self.taskChangeLike = nil
            
            switch result {
            case .success(let onePhotoResult):
                if let index = self.photos.firstIndex(where: { $0.id == onePhotoResult.photo.id }) {
                    self.photos[index].changeLike()
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ImagesListService {
    
    private func photoRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos?page=\(lastLoadedPage)&per_page=\(perPage)",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    private func likeRequest(_ photoId: String, _ isLike: Bool) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "DELETE" : "POST",
            baseUrl:  Constants.defaultApiBaseURL)
    }
}
