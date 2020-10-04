//
//  APIService.swift
//  RTRS
//
//  Created by Vlada Calic on 11/1/18.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

typealias ArticleResult = Result<Article, AppError>
typealias CategoriesResult = Result<[Category], AppError>

final class APIService {
  func article(id: Int, completion: @escaping (ArticleResult) -> Void) {
    let url = Services.article(id: id).value
    NetworkService.fetchData(url: url) { result in
      var retval: ArticleResult
      do {
        retval = .success(try result.decoded() as Article)
      } catch {
        debugPrint("Error parsing article data: \(error)")
        retval = .failure(.decodingError)
      }
      Async.call(input: retval, completion: completion)
    }
  }

  func fetchArticle(id: Int, completion: @escaping (Result<Data, AppError>) -> Void) {
    let url = Services.article(id: id).value
    NetworkService.fetchData(url: url) { result in
      guard let result = try? result.get() else { DispatchQueue.main.async { completion(.failure(.emptyData)) }; return }
      completion(.success(result))
    }
  }

  func homePage(id: Int = -1, count: Int = 30, completion: @escaping (Result<HomePageList, Error>) -> Void) {
    //let url = Services.categoryArticles(id: id, count: count).value
    let url = Services.homePage.value
    debugPrint("URL", url)
    NetworkService.fetchData(url: url) { result in
      var retval: Result<HomePageList, Error>
      do {
        let list = try result.decoded() as HomePageList
        retval = .success(list)
      } catch {
        retval = .failure(error)
      }

      DispatchQueue.main.async {
        completion(retval)
      }
    }
  }

  func categories(completion: @escaping ((CategoriesResult) -> Void)) {
    let url = Services.categoriesUrl.value
    debugPrint("URL: \(url)")
    NetworkService.fetchData(url: url) { result in
      var retval: Result<[Category], AppError>
      do {
        let list = try result.decoded() as [Category]
        retval = .success(list)
      } catch {
        debugPrint("Error in menugetter: \(error)")
        retval = .failure(AppError.emptyData)
      }
      DispatchQueue.main.async {
        completion(retval)
      }
    }
  }
}

extension APIService {}
