//
//  NetworkService.swift
//  RTRS
//
//  Created by Vlada Calic on 3/27/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation
struct NetworkService {
    
    static func getData(url: URL, completion:@escaping(Result<Data, AppError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard let response = urlResponse as? HTTPURLResponse else { completion(.failure(.requestFailed));return }

            var errorCode = -1
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    completion(.success(data))
                    return
                }
                else {
                    errorCode = 1001
                }
            } else {
                errorCode = response.statusCode
            }
            completion(.failure(AppError(code: errorCode)))
        }
        task.resume()
    }
    
    func getText(url: URL, completion:@escaping (String, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            let response = urlResponse as! HTTPURLResponse
            debugPrint("\(response.statusCode)")
            if let data = data,
                let dataString = data.string {
                completion(dataString, nil)
            } else {
                if (error != nil) {
                    completion("", error)
                } else {
                    completion("", NSError(domain: "Unknown", code: 1022, userInfo: [:]))
                }
            }
        }
        task.resume()
    }
    
    func getJson(url: URL, completion:@escaping (NSDictionary, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            let response = urlResponse as! HTTPURLResponse
            if response.statusCode != 200 {
                completion([:], error)
                return
            }
            let unknownError = NSError(domain: "Unknown", code: 1022, userInfo: [:])
            if let data = data {
                do {
                    let json =  try JSONSerialization.jsonObject(with: data,
                                                                 options: JSONSerialization.ReadingOptions(rawValue: 0))
                    if let jsonDict = json as? NSDictionary {
                        completion(jsonDict, nil)
                    } else {
                        completion([:], unknownError);
                    }
                } catch let error as NSError {
                    completion([:], error)
                }
            } else {
                if (error != nil) {
                    completion([:], error)
                } else {
                    completion([:], unknownError)
                }
            }
        }
        task.resume()
    }

    static func postData(url: URL, query:String, completion:@escaping(Result<Data, AppError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard let response = urlResponse as? HTTPURLResponse else { completion(.failure(.requestFailed));return }
            
            var errorCode = -1
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    completion(.success(data))
                    return
                }
                else {
                    errorCode = 1001
                }
            } else {
                errorCode = response.statusCode
            }
            completion(.failure(AppError(code: errorCode)))
        }
        task.resume()
        fatalError("Not implemented")
    }
    
}

/* Obsolete in Swift 5 */
enum APIResult<Value> {
    case success(Value)
    case failure(Error)
    
    func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}


enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
}

struct APIClient {
    
    typealias APIClientCompletion = (HTTPURLResponse?, Data?, AppError?) -> Void
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    func request(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(nil, nil, .invalidURL); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, .requestFailed); return
            }
            completion(httpResponse, data, nil)
        }
        task.resume()
    }
}
