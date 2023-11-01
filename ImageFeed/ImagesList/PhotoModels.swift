//
//  ImagesListModels.swift
//  ImageFeed
//
//  Created by Наиль on 16/10/23.
//

import Foundation

private let dateFormatter = ISO8601DateFormatter()

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    mutating func changeLike() {
        isLiked.toggle()
    }
}

extension Photo {
    init(result photoResult: PhotoResult){
        self.init(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: dateFormatter.date(from: photoResult.createdAt),
            welcomeDescription: photoResult.welcomeDescription,
            thumbImageURL: photoResult.thumbImageURL,
            largeImageURL: photoResult.largeImageURL,
            isLiked: photoResult.isLiked
        )
    }
    
    static var standart: Photo {
        Photo(
            id: "HegvNcZXWTE",
            size: CGSize(width: 4001.0, height: 6013.0),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "https://images.unsplash.com/photo-1682685794304-99d3d07c57d2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE2Mjh8MXwxfGFsbHwxfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=80&w=200",
            largeImageURL: "https://images.unsplash.com/photo-1682685794304-99d3d07c57d2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MTE2Mjh8MXwxfGFsbHwxfHx8fHx8Mnx8MTY5ODE4NTQ2NHw&ixlib=rb-4.0.3&q=85",
            isLiked: false)
    }
}
