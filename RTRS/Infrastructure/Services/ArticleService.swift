//
//  ArticleService.swift
//  RTRS
//
//  Created by Vlada Calic on 6/17/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

private enum ParsingStage {
  case unwrap
  case decode
  case handlebars

  var error: AppError {
    switch self {
    case .unwrap:
      return .emptyData
    case .decode:
      return .decodingError
    case .handlebars:
      return .handlebarError
    }
  }
}

struct ArticleService {
  private var api: APIService
  private let handlebars: Handlebars

  init(apiService: APIService) throws {
    api = apiService
    handlebars = try Handlebars()
  }

  // TODO: fix this error catching in accordance to Google's Swift style (ie catch Document.ReadError.permissionDenied)
  func getArticle(id: Int, completion: @escaping (Result<ParsedArticle, AppError>) -> Void) {
    api.fetchArticle(id: id) { result in
      var stage: ParsingStage
      do {
        stage = .unwrap
        let data = try result.get()
        stage = .decode
        let article = try JSONDecoder().decode(Article.self, from: data)
        stage = .handlebars
        let html = try self.handlebars.perform(article: article)
        let parsedArticle = ParsedArticle(html: html, article: article)
        Async.call(input: .success(parsedArticle), completion: completion)
      } catch {
        debugPrint("On stage \(stage) we got local error \(error)")
        Async.call(input: .failure(stage.error), completion: completion)
      }
    }
  }
}

