//
//  TemplateType.swift
//  RTRS
//
//  Created by Vlada Calic on 4/4/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

enum TemplateType: String {
    case timeSource = "timeSource"
    case title = "title"
    case lead = "lead"
    case video = "video"
    case body = "body"
    case article = "article"
    case layout = "layout"
    
    func getContent() throws -> String {
        if let _url = Bundle.main.url(forResource: self.rawValue, withExtension: "html"),
            let html = try? String(contentsOf:_url) {
            return html
        } else {
            throw AppError.missingTemplate
        }
    }
}
