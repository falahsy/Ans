//
//  AnimalExtension.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit
import Kingfisher

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension KingfisherOptionsInfo {
    static var defaultOptions: KingfisherOptionsInfo? {
        let options: KingfisherOptionsInfo? = [
            .cacheSerializer(FormatIndicatedCacheSerializer.jpeg),
            .processingQueue(.dispatch(.global(qos: .background))),
            .processor(DownsamplingImageProcessor(size: .init(width: 250, height: 250))),
            .transition(.fade(0.2))
        ]
        return options
    }
}

extension UIImage {
    static var defaultImage: UIImage? {
        return UIImage(systemName: "photo.artframe")
    }
}

extension UIColor {
    static var backgroundFavorite: UIColor {
        return UIColor(red: 168/255, green: 188/255, blue: 196/255, alpha: 1)
    }
}
