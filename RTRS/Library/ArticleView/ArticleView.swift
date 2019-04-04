//
//  ArticleView.swift
//  RTRS
//
//  Created by Vlada Calic on 2/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

struct ArticleViewConstants {
    static let ContentSizeKey = "contentSize"
}


class ArticleView: UIView {
    //private var webView:WKWebView!
    private var webConfig: WKWebViewConfiguration!
    private var javaScript: String?
    private var contentHeight: CGFloat?
    private var contentSizePooling : Bool = true

    lazy var webView : WKWebView = {
        let retval = WKWebView.init(frame: CGRect.zero)
        retval.translatesAutoresizingMaskIntoConstraints  = false
        //retval.delegate = self
        retval.uiDelegate = self
        retval.navigationDelegate = self
        retval.scrollView.delaysContentTouches = false
        retval.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        retval.scrollView.delegate = self
        return retval
    }()

    
    
    //weak var delegate : ArticleViewDelegate?
    var html: String?  {
        didSet {
            refresh()
        }
    }

    // MARK: Init methods
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
    }
    deinit {
        webView.scrollView.removeObserver(self, forKeyPath: ArticleViewConstants.ContentSizeKey)
    }


    private func commonInit() {
        layoutMargins = UIEdgeInsets.zero
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.webView)
        setupConstraints()
        webView.scrollView.addObserver(self, forKeyPath: ArticleViewConstants.ContentSizeKey, options: .new, context: nil)
    }
    
    private func setupConstraints() {
        let views = ["master": self,
                     "webView": webView] as [String : Any]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[webView]-|" ,
                                                        options: NSLayoutConstraint.FormatOptions.alignmentMask,
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[webView]-|" ,
                                                      options: NSLayoutConstraint.FormatOptions.alignmentMask,
                                                      metrics: nil,
                                                      views: views)
        addConstraints(horizontal + vertical)
    }

    

}

extension ArticleView: UIWebViewDelegate {
    
    func refresh() {
        debugPrint("Refresh")
    }
}


extension ArticleView: UIScrollViewDelegate {
    
}

extension ArticleView: WKNavigationDelegate {
    
}

extension ArticleView: WKUIDelegate {
    
}


extension ArticleView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
    
    
}
