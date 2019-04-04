//
//  Story.swift
//  RTRS
//
//  Created by Vlada Calic on 3/26/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

struct ArticleInfo: Codable {
    public var webURL: String
    public var id: String
    public var smallImageUrl: String
    public var publishDate: String
    public var title: String
    public var largeImageUrl: String
    public var introText: String
    public var twitterUrl: [String]?
    public var youtubeUrl: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "ArticleId"
        case introText = "IntroText"
        case largeImageUrl = "LargeImageUrl"
        case publishDate = "PublishDate"
        case smallImageUrl = "SmallImageUrl"
        case title = "Title"
        case webURL = "WebURL"
        case twitterUrl = "twitter_url"
        case youtubeUrl = "youtube_url"
    }
    
}


extension ArticleInfo {
    static func array(with data:Data) throws -> [ArticleInfo]  {
        do {
            return try JSONDecoder().decode([ArticleInfo].self, from: data)
        } catch let err {
            throw(err)
        }
    }
}
