//
//  ImageApiRouter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

enum ImageApiRouter {
    case getAnimalImage(query: String, page: Int)
}

extension ImageApiRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: "https://api.pexels.com/v1")!
    }
    
    var path: String {
        switch self {
        case .getAnimalImage:
            return "/search"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getAnimalImage(let query, let page):
            let params: [String: Any] = ["query": query, "page": page]
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAnimalImage:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers["Authorization"] = "F0RsC7L6viQO7bzFmZTKs7hwGWhXlwm5TjAozyXUwkTmB8INisxbwjVg"
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
