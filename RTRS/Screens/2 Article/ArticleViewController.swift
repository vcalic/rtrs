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

    @IBOutlet weak var webView: WKWebView!
    private var article: Article!
    private var html: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let h = try Handlebars()
            html = try h.perform()
        } catch (let error) {
            debugPrint("Handlebars error \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        load()
    }
}

extension ArticleViewController {
    func load() {
        if let _html = html {
            debugPrint("Loadamo stringa")
            webView.loadHTMLString(_html, baseURL: Bundle.main.bundleURL)
        } else {
            let url = Bundle.main.url(forResource: "index", withExtension: "html")!
            webView.loadFileURL(url, allowingReadAccessTo: url)
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
