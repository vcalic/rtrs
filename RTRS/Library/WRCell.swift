//
//  WRCell.swift
//  Byrccom
//
//  Created by Vlada Calic on 6/16/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Kingfisher
import UIKit

class WRCell: UITableViewCell {
  override func setSelected(_ selected: Bool, animated: Bool) {}
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}

protocol WRCellReusable {
  static var reuseIdentifier: String { get }
  static func register(in tableV: UITableView)
  static func dequeue(in tableView: UITableView, for indexPath: IndexPath) -> WRCell
}

extension WRCellReusable where Self: UITableViewCell {
  static var reuseIdentifier: String {
    return String(describing: self)
  }

  static func register(in tableView: UITableView) {
    let nib = UINib(nibName: reuseIdentifier, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
  }

  static func dequeue(in tableView: UITableView, for indexPath: IndexPath) -> WRCell {
    return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                         for: indexPath) as! WRCell
  }
}

extension UITableView {
  func dequeue<T: WRCellReusable>(for indexPath: IndexPath) -> T {
    let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath)
    return cell as! T
  }
}

extension UIImageView {
  func setImage(url: URL?) {
    if let url = url {
      let options: KingfisherOptionsInfo = [
        .transition(.fade(0.5))
      ]
      kf.setImage(with: url, options: options)
    }
  }
}
