//
//  ImageWorker.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

protocol IImageWorker {
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler)
}

class ImageWorker: IImageWorker {
    
    private let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler) {
        imageService.fetchImages(request: request, completion: completion)
        
    }
}
