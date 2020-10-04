//
//  MenuViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

final class MenuViewController: UITableViewController, StoryboardLoadable {
  static var storyboardName = "Menu"
  weak var delegate: MenuViewControllerDelegate?
  let dataSource = SectionMenu.generate()
  var selected: AppSections?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.backgroundColor = .systemRed
    navigationController?.navigationBar.barTintColor = .systemRed
    view.backgroundColor = .systemBlue
    tableView.backgroundColor = .systemBlue
    tableView.tintColor = .white
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let name = dataSource[indexPath.row].name(for: .latin)
    return MenuCell.dequeue(tableView, at: indexPath).configure(with: name) 
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    UIApplication.shared.sendAction(#selector(AppActions.didSelectMenuItem(_:)), to: nil, from: self, for: nil)
    selected = dataSource[indexPath.row]
    delegate?.didSelectSection(section: dataSource[indexPath.row], vc: self)
  }
}

extension MenuViewController {
  class func make() -> MenuViewController {
    let vc = MenuViewController.instantiate(fromStoryboard: UIStoryboard.menu)
    return vc
  }

  @objc func toggleMenu() {
    delegate?.didPressToggleMenu(self)
  }
}

protocol MenuViewControllerDelegate: class {
  func didPressToggleMenu(_ vc: MenuViewController)
  func didSelectSection(section: AppSections, vc: MenuViewController)
}

@objc protocol AppActions: AnyObject {
  func didSelectMenuItem(_ sender: MenuViewController)
}
