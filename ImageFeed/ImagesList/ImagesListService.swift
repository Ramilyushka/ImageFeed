//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Наиль on 16/10/23.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
   // static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lasLoadedPage = 1
    
    private func photoRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos?page=\(lasLoadedPage)&per_page=10",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        var request = photoRequest()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("----REQUEST PHOTOS ------")
        print(request)
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<[PhotoResult], Error>)  in
            
           // self?.currentTask = nil
            
            guard let self = self else  {
                print("GUARD ImagesListService")
                return
            }
            
            switch result {
            case .success(let photoResultArrray):
//                print("photoResultArrray")
//                print(photoResultArrray)
                
                let photoResultArray = photoResultArrray
                
                for photoResult in photoResultArray {
                    self.photos.append(Photo(result: photoResult))
                }
                lasLoadedPage += 1
                completion(.success(self.photos))
                
//                NotificationCenter.default.post(
//                    name: ImagesListService.didChangeNotification,
//                    object: self,
//                    userInfo: ["photos": photos])
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
