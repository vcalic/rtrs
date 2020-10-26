//
//  ArticleSwipeViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 6/17/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

class ArticleSwipeViewController: UIViewController {
  var articles: [Any] = []
  var indexPath: IndexPath!
  weak var delegate: ArticleSwipeViewControllerDelegate?

  private lazy var pageViewController: UIPageViewController = {
    let transitionsStyle = UIPageViewController.TransitionStyle.scroll
    let navOrientation = UIPageViewController.NavigationOrientation.horizontal
    return UIPageViewController(transitionStyle: transitionsStyle,
                                navigationOrientation: navOrientation,
                                options: nil)
  }()

  private lazy var containerView: UIView = {
    let retval = UIView(frame: view.bounds)
    view.addSubview(retval)
    return retval
  }()

  private lazy var dataSource: PageViewDataSource = { [weak self] in
    guard let sself = self else { fatalError("Not a self") }

    let dataSource = PageViewDataSource()
    dataSource.data = articles
    var configureBlock: ConfigurePageBlock = { [weak self] cell, object, index in
      guard let articleVC = cell as? ArticleViewController else { debugPrint("Not a AVC"); return }
      guard let articleInfo = object as? ArticleInfo else { debugPrint("Not an articleInfo"); return }
      sself.delegate?.configure(articleViewController: articleVC, info: articleInfo, index: index)
    }
    dataSource.setupPageViewController(
      pageViewController,
      in: containerView,
      for: sself,
      configureWith: configureBlock)
    { () -> PageViewContent in
      if let retval = sself.delegate?.makeArticleViewController() {
        retval.topView = retval.view
        return retval
      } else {
        fatalError("You need to configure this!!!")
      }
    }
    return dataSource
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let rightButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    navigationItem.rightBarButtonItem = rightButton

    _ = dataSource
    dataSource.goto(page: indexPath.row)
  }

  @objc func share(_ sender: Any) {
    let article = dataSource.data[dataSource.index] as! ArticleInfo
    let title = article.title
    let url = article.webURL
    debugPrint("Share \(title) at \(url)")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

protocol ArticleSwipeViewControllerDelegate: class {
  func configure(articleViewController: ArticleViewController, info: ArticleInfo, index: Int)
  func makeArticleViewController() -> ArticleViewController
}
