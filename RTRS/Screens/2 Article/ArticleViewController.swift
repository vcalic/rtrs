//
//  ArticleViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 2/19/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, StoryboardLoadable {

    @IBOutlet weak var articleView: ArticleView!
    private var article: Article!
    private var html: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let h = try Handlebars()
            let html = try h.perform()
            load(html)
        } catch (let error) {
            debugPrint("Handlebars error \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension ArticleViewController {
    func load(_ html:String) {
        articleView.html = html
        articleView.delegate = self
    }
}

extension ArticleViewController {
    class func make(with article:Article) -> ArticleViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = ArticleViewController.instantiate(fromStoryboard: storyboard)
        vc.article = article
        return vc
    }
}

extension ArticleViewController: ArticleViewDelegate {}
