//
//  ArticleCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 6/17/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

final class ArticleCoordinator: Coordinator {
    var parent: Coordinator?
    private let articleService: ArticleService!
    
    init(articleService: ArticleService) {
        self.articleService = articleService
    }
    
    func start(completion: CoordinatorBlock?) {
    }
}
