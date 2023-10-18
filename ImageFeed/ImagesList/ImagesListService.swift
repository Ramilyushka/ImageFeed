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
//    private var currentLoadingPage = 1
    
    private func photoRequest(page: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&per_page=10",
            httpMethod: "GET",
            baseUrl:  Constants.defaultApiBaseURL)
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
//        if currentLoadingPage == lastLoadedPage {
//            currentLoadingPage += 1
//        }
       //if let nextPage = lastLoadedPage
//        let nextPage = lastLoadedPage == nil
//        ? 1
//        : lastLoadedPage!. + 1
        
        var request = photoRequest(page: lastLoadedPage)
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        print("----REQUEST PHOTOS ------")
        print(request)
        
        currentTask = urlSession.object(for: request) {[weak self] (result: Result<[PhotoResult], Error>)  in
            
            self?.currentTask = nil
            
            guard let self = self else  {
                print("GUARD ImagesListService")
                return
            }
                
            switch result {
            case .success(let photoResultArrray):
                self.lastLoadedPage += 1
                print("---lastLoadedPage---- \(self.lastLoadedPage)")
                
                let photoResultArray = photoResultArrray
                
//                DispatchQueue.main.async {
                    for photoResult in photoResultArray {
                        self.photos.append(Photo(result: photoResult))
                    }
               // }
                
                //completion(.success(self.photos))
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": self.photos])
                
            case .failure(let error):
                print(error)
                //completion(.failure(error))
            }
        }
    }
}
