//
//  MockAnimalImageWorker.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
import Alamofire
@testable import Ans

class MockAnimalImageWorker {
    var fetchImagestCalled: Bool!
}

final class MockAnimalImageWorkerSuccess: MockAnimalImageWorker, IImageWorker {
    
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler) {
        fetchImagestCalled = true
        let url = Bundle.main.url(forResource: "ElephantImageDummy", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let response = try! jsonDecoder.decode(ImageResponse.self, from: data)
        completion(.success(response))
    }
}

final class MockAnimalImageWorkerFailed: MockAnimalImageWorker, IImageWorker {
    
    var error = NetworkError.noDataError
    
    func fetchImages(request: URLRequestConvertible, completion: @escaping ImageHandler) {
        fetchImagestCalled = true
        completion(.failure(error))
    }
}
