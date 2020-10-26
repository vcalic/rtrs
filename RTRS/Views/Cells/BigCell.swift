//
//  BigCell.swift
//  RTRS
//
//  Created by Vlada Calic on 3/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Kingfisher
import UIKit

class BigCell: WRCell, WRCellReusable {
  @IBOutlet var picture: UIImageView!
  @IBOutlet var title: UILabel!

  override func prepareForReuse() {
    super.prepareForReuse()
    picture.kf.cancelDownloadTask()
    picture.image = nil
  }

  func configure(with model: BigCellViewModel) {
    title.text = model.title
    picture.setImage(url: model.image)
  }
}

struct BigCellViewModel {
  var title: String
  var image: URL?
}

extension BigCellViewModel {
  init(with article: ArticleInfo) {
    title = article.title.decodeHTMLEntities
    image = URL(string: article.largeImageUrl)
  }
}
