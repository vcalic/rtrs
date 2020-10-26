//
//  AppError.swift
//  RTRS
//
//  Created by Vlada Calic on 12/13/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import Foundation

public enum AppError: Swift.Error {
  case generalError
  case networkError
  case httpError(code: Int, message: String)
  case invalidURL
  case requestFailed
  case emptyData
  case decodingError
  case missingMustache
  case missingMain
  case missingTemplate
  case handlebarError

  init(error: Error) {
    if error is AppError {
      self = error as! AppError
    } else {
      self = .generalError
    }
  }

  init(networkError apierror: NetworkError) {
    switch apierror {
    case .invalidResponse:
      self = .networkError
    case .networkError:
      self = .networkError
    case .serverError:
      self = .networkError
    case .requestError(let code, let message):
      self = .httpError(code: code, message: message)
    }
  }
}
