//
//  APIService.swift
//  RTRS
//
//  Created by Vlada Calic on 11/1/18.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

final class APIService {
    
    func article(id: Int, completion: @escaping(Result<Article, AppError>) -> Void) {
        let url = Services.article(id: id).value
        NetworkService.getData(url: url) { (result) in
            guard let result = try? result.get() else { DispatchQueue.main.async {completion(.failure(.emptyData))}; return}
            do {
                let article = try JSONDecoder().decode(Article.self, from: result)
                DispatchQueue.main.async { completion(.success(article)) }
            } catch (let error) {
                debugPrint("Error parsing article data: \(error)")
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }
    }
    
    func homePage(id:Int = -1, count:Int=30, completion: @escaping(Result<ArticleList, Error>) -> Void) {
        let url = Services.categoryArticles(id: id, count: count).value
        NetworkService.getData(url: url) { (result) in
            var retval: Result<ArticleList, Error>
            do {
                let list = try result.decoded() as ArticleList
                retval = .success(list)
            } catch {
                retval = .failure(error)
            }

            /*
            var retval: Result<ArticleList, Error>

            switch result {
            case .success(let data):
                do {
                    let list = try ArticleList(with: data)
                    retval = .success(list)
                } catch (let err) {
                    retval = .failure(err)
                }
            case .failure(let error):
                retval = .failure(error)
            } */
            DispatchQueue.main.async {
                completion(retval)
            }
        }
    }
}

extension APIService {
    
}


