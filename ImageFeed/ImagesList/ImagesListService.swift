//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Наиль on 16/10/23.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    
    private func photoRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos?page=\(lastLoadedPage)&per_page=10",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchPhotosNextPage(_ token: String) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        var request = photoRequest()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("----REQUEST PHOTOS ------")
        print(request)
        
        print("---LAST PAGE----\(lastLoadedPage)")
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<[PhotoResult], Error>)  in
            
            self?.currentTask = nil
            
            guard let self = self else  {
                print("GUARD ImagesListService")
                return
            }
            
            switch result {
            case .success(let photoResultArrray):
                
                let photoResultArray = photoResultArrray
                
                for photoResult in photoResultArray {
                    photos.append(Photo(result: photoResult))
                }
               // completion(.success(self.photos))
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos])
                
                lastLoadedPage += 1
                
            case .failure(let error):
                print(error)
               // completion(.failure(error))
            }
        }
    }
}
