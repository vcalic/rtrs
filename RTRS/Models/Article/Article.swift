//
//  Article.swift
//  RTRS
//
//  Created by Vlada Calic on 2/12/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

import Foundation
struct Article : Codable {
    let webURL : String
    let articleId : String
    let categoryId : String
    let categoryName : String
    let title : String
    let introText : String
    let smallImageUrl : String?
    let largeImageUrl : String?
    let publishDate : String?
    let galleryId : String?
    let galleryName : String?
    let videoUrl : String?
    let videoName : String?
    let agency : String?
    let author : String?
    let text : String
    let phtDescription : String?
    let phtAgencyID : String?
    let phtAgency : String?
    let youtube_url : [String]?
    let twitter_url : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case webURL = "WebURL"
        case articleId = "ArticleId"
        case categoryId = "CategoryId"
        case categoryName = "CategoryName"
        case title = "Title"
        case introText = "IntroText"
        case smallImageUrl = "SmallImageUrl"
        case largeImageUrl = "LargeImageUrl"
        case publishDate = "PublishDate"
        case galleryId = "GalleryId"
        case galleryName = "GalleryName"
        case videoUrl = "VideoUrl"
        case videoName = "VideoName"
        case agency = "Agency"
        case author = "Author"
        case text = "Text"
        case phtDescription = "PhtDescription"
        case phtAgencyID = "PhtAgencyID"
        case phtAgency = "PhtAgency"
        case youtube_url = "youtube_url"
        case twitter_url = "twitter_url"
    }
    
    
}
