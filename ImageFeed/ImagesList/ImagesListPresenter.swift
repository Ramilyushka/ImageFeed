//
//  ImagesList.swift
//  ImageFeed
//
//  Created by Наиль on 24/10/23.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol {
    var photos: [Photo] { get }
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotos()
    func fetchChangeLike(index: Int, completion: @escaping (Result<Void, Error>)->Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    
    let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private (set) var photos: [Photo] = []
    
    init() {
        self.imagesListService = ImagesListService.shared
    }
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        serviceObserver()
        updatePhotos()
    }
    
    private func serviceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: imagesListService,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updatePhotos()
                }
    }
    
    func updatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount && oldCount != 0 {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchChangeLike(index: Int, completion: @escaping (Result<Void, Error>)->Void) {
        
        let photo = photos[index]
        
        imagesListService.fetchChangeLike(photoId: photo.id, isLike: photo.isLiked){ result in
            switch result {
            case .success(_):
                self.photos = self.imagesListService.photos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
