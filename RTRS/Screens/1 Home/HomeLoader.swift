//
//  HomeLoader.swift
//  RTRS
//
//  Created by Vlada Calic on 4/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation


final class HomeLoader {
    
    typealias HomeHandler = (Result<ArticleList, AppError>) -> Void
    var placeholder = ""
    /* func loadUser(withID id:Int) -> Future<ArticleList> {
     
     } */
    
    func loadUser(withID id: Int, completionHandler: @escaping HomeHandler) {
        let url = Services.categoryArticles(id: -1, count: 30).value
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.placeholder = ""
            if let error = error {
                let appError = AppError(error: error)
                completionHandler(.failure(appError))
            } else {
                do {
                    // let user: User = try unbox(data: data ?? Data())
                    if let data = data {
                        let list = try ArticleList(with: data)
                        completionHandler(.success(list))
                    } else {
                        completionHandler(.failure(.generalError))
                    }
                    
                } catch {
                    completionHandler(.failure(AppError(error:error)))
                }
            }
        }
        
        task.resume()
    }
    

}
