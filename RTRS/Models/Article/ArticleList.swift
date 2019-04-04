//
//  ArticleList.swift
//  RTRS
//
//  Created by Vlada Calic on 3/27/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

struct ArticleList: Codable {
    let news:[ArticleInfo]
    let top:[ArticleInfo]
    private enum CodingKeys: String, CodingKey {
        case news = "news_all"
        case top = "news_top"
    }

}

extension ArticleList {
    init(with data:Data) throws  {
        do {
            self = try JSONDecoder().decode(ArticleList.self, from: data)
        } catch let err {
            throw(err)
        }
    }
}
