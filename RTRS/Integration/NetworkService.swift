//
//  NetworkService.swift
//  Byrccom
//
//  Created by Vlada Calic on 3/27/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

typealias NetworkResult = Result<Data, NetworkError>

enum NetworkError: Error {
  case networkError(Error)
  case serverError // HTTP 5xx
  case requestError(Int, String) // HTTP 4xx
  case invalidResponse
}

private func handle(data: Data?,
                    urlResponse: URLResponse?,
                    error: Error?,
                    completion: @escaping (NetworkResult) -> Void)
{
  if let error = error {
    DispatchQueue.main.async {
      completion(.failure(.networkError(error)))
    }
    return
  }
  guard let response = urlResponse as? HTTPURLResponse, let data = data else {
    DispatchQueue.main.async {
      completion(.failure(.invalidResponse))
    }
    return
  }

  switch response.statusCode {
  case 200 ... 299:
    DispatchQueue.main.async {
      completion(.success(data))
    }

  case 400 ... 499:
    let body = String(data: data, encoding: .utf8) ?? "no data"
    DispatchQueue.main.async {
      completion(.failure(.requestError(response.statusCode, body)))
    }
  case 500 ... 599:
    DispatchQueue.main.async {
      completion(.failure(.serverError))
    }

  default:
    fatalError("Unhandled HTTP status code")
  }
}

enum NetworkService {
  static func fetchData(url: URL, completion: @escaping (NetworkResult) -> Void) {
    NetworkService.perform(request: URLRequest(url: url), completion: completion)
  }

  static func postData(url: URL, data: [String: String], completion: @escaping (NetworkResult) -> Void) {
    let request = URLRequest.postWith(url: url, data: data)
    perform(request: request, completion: completion)
  }

  private static func perform(request: URLRequest, completion: @escaping (NetworkResult) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(.networkError(error)))
        }
        return
      }
      guard let response = urlResponse as? HTTPURLResponse, let data = data else {
        DispatchQueue.main.async {
          completion(.failure(.invalidResponse))
        }
        return
      }

      switch response.statusCode {
      case 200 ... 299:
        DispatchQueue.main.async {
          completion(.success(data))
        }

      case 400 ... 499:
        let body = String(data: data, encoding: .utf8) ?? "no data"
        DispatchQueue.main.async {
          completion(.failure(.requestError(response.statusCode, body)))
        }
      case 500 ... 599:
        DispatchQueue.main.async {
          completion(.failure(.serverError))
        }

      default:
        fatalError("Unhandled HTTP status code")
      }
    }
    task.resume()
  }

  static func postData(url: URL, query: String, completion: @escaping (NetworkResult) -> Void) {
    fatalError("Not implemented")
  }
}

extension URLRequest: Appliable {}

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
  private let baseURL: URL //  = URL(string: "https://jsonplaceholder.typicode.com")!
  init(baseURL: URL) {
    self.baseURL = baseURL
  }

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

    let task = session.dataTask(with: url) { data, response, _ in
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(nil, nil, .requestFailed); return
      }
      completion(httpResponse, data, nil)
    }
    task.resume()
  }
}
