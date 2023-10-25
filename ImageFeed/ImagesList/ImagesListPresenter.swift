//
//  ImagesList.swift
//  ImageFeed
//
//  Created by Наиль on 24/10/23.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var photos: [Photo] { get }
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotos()
    func fetchChangeLike(photo: Photo, completion: @escaping (Result<Void, Error>)->Void)
    func calculateHeightRow(size: CGSize, widthBounds: Double) -> CGFloat
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    
    let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private (set) var photos: [Photo] = []
    
    init() {
        self.imagesListService = ImagesListService.shared
        serviceObserver()
    }
    
    init(view: ImagesListViewControllerProtocol, imagesListService: ImagesListServiceProtocol) {
        self.view = view
        self.imagesListService = imagesListService
        serviceObserver()
    }
    
    func viewDidLoad() {
        view?.setTableView()
        fetchPhotos()
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
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    private func updatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func calculateHeightRow(size: CGSize, widthBounds: Double) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = widthBounds - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func fetchChangeLike(photo: Photo, completion: @escaping (Result<Void, Error>)->Void) {
        
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
