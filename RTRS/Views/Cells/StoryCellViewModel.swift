//
//  StoryCellViewModel.swift
//  RTRS
//
//  Created by Vlada Calic on 6/16/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

struct StoryCellViewModel {
  var title: String
  var introText: String
  var image: URL?
}

extension StoryCellViewModel {
  init(with articleInfo: ArticleInfo) {
    title = articleInfo.title.decodeHTMLEntities
    introText = articleInfo.introText.decodeHTMLEntities
    image = URL(string: articleInfo.smallImageUrl)
  }
}
