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
    
    lazy private var pageViewController: UIPageViewController = {
        let transitionsStyle = UIPageViewController.TransitionStyle.scroll
        let navOrientation = UIPageViewController.NavigationOrientation.horizontal
        return UIPageViewController(transitionStyle: transitionsStyle,
                                    navigationOrientation: navOrientation,
                                    options: nil)
    }()
    
    lazy private var containerView: UIView = {
        let retval = UIView(frame: view.bounds)
        view.addSubview(retval)
        return retval
    }()
    
    lazy private var dataSource: PageViewDataSource = { [weak self] in
        guard let sself = self else { fatalError("Not a self") }

       let dataSource = PageViewDataSource()
        dataSource.data = articles
        var configureBlock: ConfigurePageBlock = { [weak self] (cell, object, index) in
            guard let articleVC = cell as? ArticleViewController else { debugPrint("Not a AVC"); return }
            guard let articleInfo = object as? ArticleInfo else { debugPrint("Not an articleInfo"); return }
            
        }
        dataSource.setupPageViewController(pageViewController,
                                           in: containerView,
                                           for: sself,
                                           configureWith:configureBlock)
        { ()-> PageViewContent in
            return (sself.delegate?.makeArticleViewController())!
        }
        return dataSource
    }()

}

protocol ArticleSwipeViewControllerDelegate: class {
    func configure(articleViewController: ArticleViewController, info: ArticleInfo, index: Int)
    func makeArticleViewController() -> ArticleViewController
}
