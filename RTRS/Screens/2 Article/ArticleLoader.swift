//
//  ArticleLoader.swift
//  RTRS
//
//  Created by Vlada Calic on 4/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation


class ArticleLoader {
    //let article: Article
    let id: Int
    let api: APIService
    let handlebars: Handlebars
    var content: Observable<String> = Observable(value: "")

    init(apiService: APIService, articleId: Int) throws {
        self.id = articleId
        api = apiService
        handlebars = try Handlebars()
    }
    func start() {
        api.article(id: id) { [unowned self] (result) in
            do {
                let article = try result.get()
                let html = try self.handlebars.perform(article: article)
                self.content.update(with: html)
            } catch (let error) {
                debugPrint("Handlebars error \(error)")
            }
        }
    }
}
