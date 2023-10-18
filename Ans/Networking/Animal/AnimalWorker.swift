//
//  AnimalWorker.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

protocol IAnimalWorker {
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler)
}

class AnimalWorker: IAnimalWorker {
    
    private let animalService: AnimalServiceProtocol
    
    init(animalService: AnimalServiceProtocol) {
        self.animalService = animalService
    }
    
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler) {
        animalService.fetchAnimalList(request: request, completion: completion)
    }
}
