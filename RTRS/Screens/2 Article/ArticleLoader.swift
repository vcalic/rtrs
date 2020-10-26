//
//  ArticleLoader.swift
//  RTRS
//
//  Created by Vlada Calic on 4/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

final class ArticleLoader {
  // let article: Article
  let id: Int
  let articleService: ArticleService
  var content: Observable<String> = Observable(value: "")

  init(articleService: ArticleService, articleId: Int) throws {
    self.id = articleId
    self.articleService = articleService
  }

  func start() {
    articleService.getArticle(id: id) { [weak self] result in
      do {
        let parsedArticle = try result.get()
        self?.content.update(with: parsedArticle.html)
      } catch {
        debugPrint("Got error \(error)")
      }
    }
  }
}
