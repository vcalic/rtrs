//
//  StoryCell.swift
//  RTRS
//
//  Created by Vlada Calic on 3/16/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import Kingfisher

class StoryCell: WRCell, WRCellReusable {

    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var introText: UILabel!

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
