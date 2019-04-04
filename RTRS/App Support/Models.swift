//
//  Models.swift
//  RTRS
//
//  Created by Vlada Calic on 11/1/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import Foundation

struct story {
    public var webURL: String
    public var id: String
    public var smallImageUrl: String
    public var publishDate: String
    public var title: String
    public var largeImageUrl: String
    public var introText: String
    public var twitterUrl: [Any]?
    public var youtubeUrl: [Any]?
    
    init(_ dictionary:NSDictionary) {
        id = dictionary["ArticleId"] as! String
        webURL = dictionary["WebURL"] as! String
        smallImageUrl = dictionary["SmallImageUrl"] as! String
        largeImageUrl = dictionary["LargeImageUrl"] as! String
        publishDate = dictionary["PublishDate"] as! String
        title = dictionary["title"] as! String
        introText = dictionary["introText"] as! String
        twitterUrl = dictionary["twitter_url"] as! [Any]?
        youtubeUrl = dictionary["youtube_url"] as! [Any]?
    }
}


