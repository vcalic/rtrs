//
//  ArticleView.swift
//  RTRS
//
//  Created by Vlada Calic on 2/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import JavaScriptCore
import UIKit
import WebKit

struct ArticleViewConstants {
  static let ContentSizeKey = "contentSize"
}

final class ArticleView: UIView {
  private var baseHTML = Bundle.main.bundleURL
  // var baseHTML = Bundle.main.url(forResource: "HTMLResources", withExtension: nil)!

  // MARK: - Properties

  private var isPad = false
  private var javaScript: String!
  private var contentHeight: CGFloat?
  private var contentSizePooling: Bool = true
  weak var delegate: ArticleViewDelegate?

  lazy var webView: WKWebView = {
    let retval = WKWebView(frame: .zero, configuration: webConfig).apply {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.uiDelegate = self
      $0.navigationDelegate = self
      $0.scrollView.delaysContentTouches = false
      $0.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
      $0.scrollView.delegate = self
    }
    return retval
  }()

  private lazy var webConfig: WKWebViewConfiguration = {
    let retval = WKWebViewConfiguration()
    if let path = Bundle.main.url(forResource: "webkit", withExtension: "js"),
       let js = try? String(contentsOf: path)
    {
      self.javaScript = js
      let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
      let userController = WKUserContentController()
      userController.addUserScript(userScript)

      for message in ArticleMessage.allCases {
        userController.add(self, name: message.rawValue)
      }
      retval.userContentController = userController
    } else {
      fatalError("JS file missing!!!!!")
    }
    return retval
  }()

  var html: String? {
    didSet {
      refresh()
    }
  }

  // MARK: -

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
    addSubview(webView)
    setupConstraints()
    setDefaultUserAgent(with: "RTRS iOS App/1.0")
    webView.scrollView.addObserver(self, forKeyPath: ArticleViewConstants.ContentSizeKey, options: .new, context: nil)
  }
}

// MARK: - Tools

extension ArticleView {
  func refresh() {
    webView.loadHTMLString(html!, baseURL: baseHTML)
  }

  func scrollToTop() {
    webView.scrollView.contentInset = .zero
  }

  func tagAt(point: CGPoint) {
    // TODO: complete it
    let javaScript = "getTags(\(point.x), \(point.y))"
    webView.evaluateJavaScript(javaScript) { result, _ in
      debugPrint("Result: \(String(describing: result))")
    }
  }
}

// MARK: - UIWebViewDelegate

extension ArticleView: UIWebViewDelegate {}

// MARK: - ScrollViewDelegate

extension ArticleView: UIScrollViewDelegate {}

// MARK: - WKNavigation delegate

extension ArticleView: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
  {
    let inType = navigationAction.navigationType
    let inRequest = navigationAction.request
    if let isFile = inRequest.url?.scheme?.starts(with: "file"), isFile == true {
      decisionHandler(.allow)
      return
    }
    var retval = true
    // passing decission to ArticleViewDelegate object
    if let _retval = delegate?.shouldStartLoad(self,
                                               request: inRequest,
                                               navigationType: inType)
    {
      retval = _retval
    }
    if retval {
      decisionHandler(.allow)
    } else {
      decisionHandler(.cancel)
    }
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // TODO: do we need both didFinishNetworking and didFinishLoad??
    delegate?.didFinishNetworking(self)

    if isPad {
      webView.scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height)
    }
    webView.evaluateJavaScript(javaScript, completionHandler: nil)
    webView.evaluateJavaScript("""
      var bridge = new WebKit();
      let console = {log:(str) => {bridge.debugPrint(str)}};
      console.log("Here we are")
    """, completionHandler: nil)

    if contentSizePooling {
      /* let javaScript = """
       previousValue=0;setInterval(function(){document.body.offsetHeight!=previousValue&&(previousValue=document.body.offsetHeight,window.webkit.messageHandlers.contentHeight.postMessage(previousValue))},200);
       """ */

      webView.evaluateJavaScript("""
          bridge.startLoop();
      """, completionHandler: nil)
    }

    delegate?.didFinishLoad(self)
  }

  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    debugPrint("Did fail navigation \(error)")
  }
}

// MARK: - WKUIDelegate delegate

extension ArticleView: WKUIDelegate {}

// MARK: - WKScriptMessageHandler delegate

extension ArticleView: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    let name = message.name.trimmingCharacters(in: .whitespacesAndNewlines)
    let badMessage = "ArticleView.badMessage: \(name)"
    if let function = ArticleMessage(rawValue: message.name) {
      switch function {
      case .documentHeight:
        guard let contentHeight = (message.body as? NSNumber)?.floatValue else { debugPrint(badMessage); return }
        DispatchQueue.main.async {
          self.delegate?.didGetContentHeight(self, contentHeight: CGFloat(contentHeight), source: .javaScript)
        }
      case .debugPrint:
        debugPrint("JSMessage: \(message.body)")
      case .getURL, .postURL:
        function.urlCall(message: message) { message in
          self.webView.evaluateJavaScript(message, completionHandler: nil)
        }
      case .nullMessage:
        debugPrint("Null message")
      }
    }
  }
}

// MARK: - Setup

extension ArticleView {
  func setDefaultUserAgent(with suffix: String) {
    DispatchQueue.once(token: "com.byrccom.articleView") {
      let webZero = WKWebView(frame: .zero)
      webZero.evaluateJavaScript("") { result, _ in
        if let _res = result {
          let ua = ["UserAgent": "\(_res) - \(suffix)"]
          UserDefaults.standard.register(defaults: ua)
          UserDefaults.standard.synchronize()
        }
      }
    }
  }

  private func setupConstraints() {
    let views = ["master": self,
                 "webView": webView] as [String: Any]
    let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[webView]-|",
                                                    options: NSLayoutConstraint.FormatOptions.alignmentMask,
                                                    metrics: nil,
                                                    views: views)
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[webView]-|",
                                                  options: NSLayoutConstraint.FormatOptions.alignmentMask,
                                                  metrics: nil,
                                                  views: views)
    addConstraints(horizontal + vertical)
  }
}

// MARK: - Observer

extension ArticleView {
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey: Any]?,
                             context: UnsafeMutableRawPointer?)
  {
    enum LocalError: Error {
      case badChange
      case badChangeKey
      case badPath
    }

    do {
      let _change = try change.or(LocalError.badChange)
      let size = try (_change[NSKeyValueChangeKey(rawValue: "new")] as? CGSize).or(LocalError.badChangeKey)
      let path = try keyPath.or(LocalError.badPath)
      if path == ArticleViewConstants.ContentSizeKey {
        delegate?.didGetContentHeight(self, contentHeight: size.height, source: .scrollView)
      }
    } catch {
      debugPrint("ArticleView.observeValue error: \(error)")
    }
  }
}
