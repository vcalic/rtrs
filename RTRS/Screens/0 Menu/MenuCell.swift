//
//  MenuCell.swift
//  RTRS
//
//  Created by Vlada Calic on 3/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
  private static let reuseIdentifier = "MenuCell"
  override func setSelected(_ selected: Bool, animated: Bool) {}
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {}

  func configure(with text: String) -> MenuCell {
    backgroundColor = .systemBlue
    tintColor = .white
    textLabel?.textColor = .white
    selectedBackgroundView = UIView().apply {
      $0.backgroundColor = .systemTeal
    }
    textLabel?.text = text
    return self
  }
}

extension MenuCell {
  static func dequeue(_ tableView: UITableView, at indexPath: IndexPath) -> MenuCell {
    return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
  }
}
