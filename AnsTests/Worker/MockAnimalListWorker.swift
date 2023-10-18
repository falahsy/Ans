//
//  MockAnimalListWorker.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
import Alamofire
@testable import Ans

enum NetworkError: Error {
    case noDataError
}

class MockAnimalListWorker {
    var fetchAnimalListCalled: Bool!
}

final class MockAnimalListWorkerSuccess: MockAnimalListWorker, IAnimalWorker {
    
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler) {
        fetchAnimalListCalled = true
        let url = Bundle.main.url(forResource: "AnimalListDummy", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let response = try! jsonDecoder.decode(AnimalListResponse.self, from: data)
        completion(.success(response))
    }
}

final class MockAnimalListWorkerFailed: MockAnimalListWorker, IAnimalWorker {
    
    var error = NetworkError.noDataError
    
    func fetchAnimalList(request: URLRequestConvertible, completion: @escaping AnimalListHandler) {
        fetchAnimalListCalled = true
        completion(.failure(error))
    }
}
