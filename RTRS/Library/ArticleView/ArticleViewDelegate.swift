//
//  ArticleViewDelegate.swift
//  RTRS
//
//  Created by Vlada Calic on 2/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import JavaScriptCore

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
                         navigationType inType : Any) -> Bool
    
    func didGotContentHeight(_ sender:ArticleView,
                             contentHeight:CGFloat,
                             source:ArticleViewContentHeightSource)
    
    func didExposeJSContext(_ sender:ArticleView,
                            context: JSContext?)
    
}

// MARK: - ArticleViewDelegate Extension

// Pošto su svi metodi optional pravimo default implementacije koje ne rade ništa
// Osim contexta, njega ćemo da definišemo ovde pa nek ga svi šeruju. A ostavljamo mogućnost da se promeni

extension  ArticleViewDelegate {
    func didFinishNetworking(_ sender: ArticleView) {
    }
    
    func didFinishLoad(_ sender: ArticleView) {
    }
    
    func shouldStartLoad(_ sender: ArticleView, request inRequest: URLRequest, navigationType inType: Any) -> Bool {
        return false
    }
    
    func didGotContentHeight(_ sender: ArticleView, contentHeight: CGFloat, source: ArticleViewContentHeightSource) {
    }
    
    func didExposeJSContext(_ sender: ArticleView, context: JSContext?) {
        
    }
    
}
