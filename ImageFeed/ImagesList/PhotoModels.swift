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
}
