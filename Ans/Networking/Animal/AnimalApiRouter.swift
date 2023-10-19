//
//  AnimalApiRouter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

enum AnimalApiRouter {
    case getAnimal(name: String)
}

extension AnimalApiRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: "https://api.api-ninjas.com/v1")!
    }
    
    var path: String {
        switch self {
        case .getAnimal:
            return "/animals"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getAnimal(let name):
            let params: [String: Any] = ["name": name]
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAnimal:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        let apiKey = Bundle.main.infoDictionary?["API_KEY_NINJA"] as? String ?? ""
        headers["X-Api-Key"] = apiKey
        return headers
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
