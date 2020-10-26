//
//  StoryCell.swift
//  RTRS
//
//  Created by Vlada Calic on 3/16/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Kingfisher
import UIKit

class StoryCell: WRCell, WRCellReusable {
  @IBOutlet var smallImage: UIImageView!
  @IBOutlet var title: UILabel!
  @IBOutlet var introText: UILabel!

  func configure(with model: StoryCellViewModel) {
    title.text = model.title
    introText.text = model.introText
    smallImage.setImage(url: model.image)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    smallImage.kf.cancelDownloadTask()
    smallImage.image = nil
  }
}
