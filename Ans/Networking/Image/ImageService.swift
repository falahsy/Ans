//
//  ImageService.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

typealias ImageHandler = (Result<ImageResponse, Error>) -> Void

protocol ImageServiceProtocol {
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler)
}

class ImageService: ImageServiceProtocol {
    
    static let shared = ImageService()
    
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler) {
        AF.request(request).responseData { response in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                    completion(.success(response))
                } catch (let error){
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
