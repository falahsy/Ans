//
//  ImageResponse.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation

struct ImageResponse: Codable {
    let page: Int
    let photos: [Photo]
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case photos
        case nextPage = "next_page"
    }
}

struct Photo: Codable {
    let id: Int
    let src: Src
    var liked: Bool
}

struct Src: Codable {
    let landscape: String
}

