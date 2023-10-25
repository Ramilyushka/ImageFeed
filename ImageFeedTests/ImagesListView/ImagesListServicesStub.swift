//
//  ImagesListServicesStub.swift
//  ImageFeedTests
//
//  Created by Наиль on 25/10/23.
//

import Foundation
@testable import ImageFeed

final class ImagesListServicesStub: ImagesListServiceProtocol {
    
    var fetchPhotosNextPageCalled = false
    var fetchChangeLikeCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func fetchChangeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        fetchChangeLikeCalled = true
    }
    
    var photos: [ImageFeed.Photo] = [
        ImageFeed.Photo(
        id: "HegvNcZXWTE",
        size: CGSize(width: 4001.0, height: 6013.0),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURL: "https://images.unsplash.com/photo-1682685794304-99d3d07c57d2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE2Mjh8MXwxfGFsbHwxfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=80&w=200",
        largeImageURL: "https://images.unsplash.com/photo-1682685794304-99d3d07c57d2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MTE2Mjh8MXwxfGFsbHwxfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=85",
        isLiked: false),

        ImageFeed.Photo(
        id: "2oNR3ReEL-c",
        size: CGSize(width: 4338.0, height: 5422.0),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURL: "https://images.unsplash.com/photo-1697747886061-a6dc7d293554?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE2Mjh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=80&w=200",
        largeImageURL: "https://images.unsplash.com/photo-1697747886061-a6dc7d293554?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MTE2Mjh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=85",
        isLiked: false)]
}
