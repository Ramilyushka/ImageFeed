//
//  PhotoModelsCodable.swift
//  ImageFeed
//
//  Created by Наиль on 21/10/23.
//

import Foundation

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
    let createdAt: String
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

struct OnePhotoResult: Codable {
    let photo: PhotoResult
}
