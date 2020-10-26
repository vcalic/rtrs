//
//  MainCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 4/22/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

final class MainCoordinator: Coordinator {
  var parent: Coordinator?
  private let apiService: APIService
  private let articleService: ArticleService

  init(apiService: APIService, articleService: ArticleService) {
    self.apiService = apiService
    self.articleService = articleService
  }

  func start(completion: CoordinatorBlock?) {}
}
