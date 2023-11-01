//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Наиль on 25/10/23.
//

import UIKit
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {

    
    var photos: [ImageFeed.Photo] = []
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotos() {
       //code
    }
    
    func fetchChangeLike(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        //code
    }
    
    func calculateHeightRow(size: CGSize, widthBounds: Double) -> CGFloat {
        return CGFloat()
    }
}
