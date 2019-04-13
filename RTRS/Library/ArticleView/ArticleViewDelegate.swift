//
//  ArticleViewDelegate.swift
//  RTRS
//
//  Created by Vlada Calic on 2/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

enum ArticleViewContentHeightSource {
    case scrollView
    case javaScript
}


// MARK: - ArticleViewDelegate
protocol  ArticleViewDelegate : class {
    func didFinishNetworking(_ sender:ArticleView)
    func didStartNetworking(_ sender:ArticleView)
    func didFinishLoad(_ sender:ArticleView)
    
    func shouldStartLoad(_ sender:ArticleView,
                         request inRequest: URLRequest,
                         navigationType inType : WKNavigationType) -> Bool
    
    func didGetContentHeight(_ sender:ArticleView,
                             contentHeight:CGFloat,
                             source:ArticleViewContentHeightSource)
}

// MARK: - ArticleViewDelegate Extension

// Pošto su svi metodi optional pravimo default implementacije koje ne rade ništa
// Osim contexta, njega ćemo da definišemo ovde pa nek ga svi šeruju. A ostavljamo mogućnost da se promeni

extension  ArticleViewDelegate {
    func didFinishNetworking(_ sender: ArticleView) {
    }
    
    func didFinishLoad(_ sender: ArticleView) {
          }
    
    func shouldStartLoad(_ sender: ArticleView, request inRequest: URLRequest, navigationType inType: WKNavigationType) -> Bool {
        debugPrint("request \(inRequest)")
        switch inType {
            
        case .linkActivated:
            debugPrint("Type linkActivated")
        case .formSubmitted:
            debugPrint("Type formSubmitted")
        case .backForward:
            debugPrint("Type backForward")
        case .reload:
            debugPrint("Type reload")
        case .formResubmitted:
            debugPrint("Type formResubmitted")
        case .other:
            debugPrint("Type other")
        @unknown default:
            debugPrint("Type unknown")
        }
        return true
      }
    
    func didGetContentHeight(_ sender: ArticleView, contentHeight: CGFloat, source: ArticleViewContentHeightSource) {
    }
    func didStartNetworking(_ sender: ArticleView) {
    }

}
