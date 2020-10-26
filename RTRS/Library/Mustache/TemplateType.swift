//
//  TemplateType.swift
//  RTRS
//
//  Created by Vlada Calic on 4/4/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

enum TemplateType: String {
  case timeSource
  case title
  case lead
  case video
  case body
  case article
  case layout

  func getContent() throws -> String {
    if let _url = Bundle.main.url(forResource: rawValue, withExtension: "html"),
       let html = try? String(contentsOf: _url)
    {
      return html
    } else {
      throw AppError.missingTemplate
    }
  }
}
