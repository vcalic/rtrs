//
//  ArticleViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 2/19/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import WebKit

final class ArticleViewController: UIViewController, StoryboardLoadable, PageViewContent {

    static var storyboardName = "Main"

    @IBOutlet weak var articleView: ArticleView!
    weak var delegate: ArticleViewControllerDelegate?
    var topView: UIView?
    var index: Int = 0
    
    private var articleLoader: ArticleLoader!
    private var html: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView = view
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("Soy yo")
    }
}

extension ArticleViewController {
    func setup() {
        articleView.delegate = self
        articleLoader.content.addObserver(self) { (vc, html) in
            vc.articleView.html = html
        }
        delegate?.didLoad(self)
    }
}

extension ArticleViewController {
    class func make(with articleLoader: ArticleLoader, delegate:ArticleViewControllerDelegate) -> ArticleViewController {
        let vc = ArticleViewController.instantiate()
        vc.articleLoader = articleLoader
        vc.delegate = delegate
        return vc
    }
}

extension ArticleViewController: ArticleViewDelegate {
    
    func shouldStartLoad(_ sender: ArticleView, request inRequest: URLRequest, navigationType inType: WKNavigationType) -> Bool {
        if let url = inRequest.url {
            return delegate?.shouldAllow(url: url) ?? false
        } else {
            return false
        }
    }
}

protocol ArticleViewControllerDelegate: class {
    func didLoad(_ articleViewController: ArticleViewController)
    func shouldAllow(url: URL) -> Bool
}
