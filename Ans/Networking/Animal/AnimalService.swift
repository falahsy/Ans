//
//  AnimalService.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

typealias AnimalListHandler = (Result<AnimalListResponse, Error>) -> Void

protocol AnimalServiceProtocol {
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler)
}

class AnimalService: AnimalServiceProtocol {
    
    static let shared = AnimalService()
    
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler) {
        AF.request(request).responseData { response in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(AnimalListResponse.self, from: data)
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
