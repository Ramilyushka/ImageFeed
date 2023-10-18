//
//  ImagesListModels.swift
//  ImageFeed
//
//  Created by Наиль on 16/10/23.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(result photoResult: PhotoResult){
        self.init(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: photoResult.createdAt,
            welcomeDescription: photoResult.welcomeDescription,
            thumbImageURL: photoResult.thumbImageURL,
            largeImageURL: photoResult.largeImageURL,
            isLiked: photoResult.isLiked
        )
    }
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let width: Double
    let height: Double
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool
    let photoURLs: PhotoURLs
    var thumbImageURL: String { return photoURLs.thumb }
    var largeImageURL: String { return photoURLs.full }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case photoURLs = "urls"
    }
}

struct PhotoResultArray: Codable {
    let photoResultArray: [PhotoResult]
}
