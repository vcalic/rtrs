//
//  URL.swift
//  RTRS
//
//  Created by Vlada Calic on 7/19/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import Foundation


struct URLS {
    var CategoryArticles = "service=category_articles&count=30&id="
    var HomePage = "service=home_news"
    var Article = "service=article&id="
    var PhotoGalleryList   =  "service=gallery_serial&count=25"
    var PhotoGallery   =  "service=gallery_content&id="
    var TVNews   =  "service=progart_serial&type=chnl&id=1"
    var RadioNews   =  "service=progart_serial&type=chnl&id=2"
    var NewsArticle   =  "service=progart&id="
    var TVAnnouncements   =  "service=progann_serial&count=50&chnl=1"
    var RadioAnnouncements   =  "service=progann_serial&count=50&chnl=2"
    var AnnouncementArticle   =  "service=progann&id="
    var TVBroadcast   =  "service=programs&chnl=1"
    var RadioBroadcast   =  "service=programs&chnl=2"
    var BroadcastArticle   =  "service=program&id="
    var CategoriesUrl  =  "service=categories&type=news_serious"
    var VideoGalleryList   =  "service=video_serial&count=25"
    var AudioGalleryList   =  "service=audio_serial&count=25"
    var TVProgramSchedule   =  "service=epg&chnl=1&date="
    var RadioProgramSchedule   =  "service=epg&chnl=2&date="
    var TVProgramScheduleDates   =  "service=epg&chnl=1&limit=7"
    var RadioProgramScheduleDates   =  "service=epg&chnl=2&limit=7"
    var TVCurrentBroadcast   =  "service=epg_now&chnl=1"
    var RadioCurrentBroadcastUrl = "service=epg_now&chnl=2"
    
}

enum Services {
    case categoryArticles(id: Int, count:Int)
    case homePage
    case article(id: Int)
    case photoGalleryList(count: Int)
    case photoGallery(id: Int)
    case tvNews
    case radioNews
    case newsArticle(id: Int)
    case tvAnnouncements(count: Int)
    case radioAnnouncements(count: Int)
    case announcementArticle(id: Int)
    case broadcastArticle(id: Int)
    case categoriesUrl
    case videoGalleryList(count: Int)
    case audioGalleryList(count: Int)
    case tvProgramSchedule(date: Date)
    case radioProgramSchedule(date: Date)
    case tvProgramScheduleDates(limit: Int)
    case radioProgramScheduleDates(limit: Int)
    case tvCurrentBroadcast
    case radioCurrentBroadcastUrl
    case tvBroadcast
    case radioBroadcast
    
    fileprivate var urlString: String {
        switch self {
        case .categoryArticles(let id, let count):
            if id > 0 {
                return "service=category_articles&count=\(count)&id=\(id)"
            } else {
                return "service=category_articles&count=\(count)&id="
            }
        case .homePage:
            return "service=home_news"
        case .article(let id):
            return "service=article&id=\(id)"
        case .photoGalleryList(let count):
            return "service=gallery_serial&count=\(count)"
        case .photoGallery(let id):
            return "service=gallery_content&id=\(id)"
        case .tvNews:
            return "service=progart_serial&type=chnl&id=1"
        case .radioNews:
            return "service=progart_serial&type=chnl&id=2"
        case .newsArticle(let id):
            return "service=progart&id=\(id)"
        case .tvAnnouncements(let count):
            return "service=progann_serial&count=\(count)&chnl=1"
        case .radioAnnouncements(let count):
            debugPrint("\(count)")
            return "service=progann_serial&count=50&chnl=2"
        case .announcementArticle(let id):
            return "service=progann&id=\(id)"
        case .broadcastArticle(let id):
            return "service=program&id=\(id)"
        case .categoriesUrl:
            return "service=categories&type=news_serious"
        case .videoGalleryList(let count):
            return "service=video_serial&count=\(count)"
        case .audioGalleryList(let count):
            return "service=audio_serial&count=\(count)"
        case .tvProgramSchedule(let date):
            debugPrint("Date \(date)")
            //TODO: calculate
            let dateString = "" 
            return "service=epg&chnl=1&date=\(dateString)"
        case .radioProgramSchedule(let date):
            debugPrint("Date \(date)")
            //TODO: calculate
            let dateString = ""
            return "service=epg&chnl=2&date=\(dateString)"
        case .tvProgramScheduleDates(let limit):
            return "service=epg&chnl=1&limit=\(limit)"
        case .radioProgramScheduleDates(let limit):
            return "service=epg&chnl=2&limit=\(limit)"
        case .tvCurrentBroadcast:
            return "service=epg_now&chnl=1"
        case .radioCurrentBroadcastUrl:
            return "service=epg_now&chnl=2"
        case .tvBroadcast:
            return "service=programs&chnl=1"
        case .radioBroadcast:
            return "service=programs&chnl=2"
        
    }
    
    }
    
    var value: URL {
        let val = Endpoints_Values()
        let urlString = "\(val.latinDomain)\(val.apiScript)?\(self.urlString)"
        return URL(string: urlString)!
    }
    
    func buildUrl(_ baseURL: URL, queryItems: [URLQueryItem] = []) -> Result<URL, AppError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url?.appendingPathComponent("/") else {
            //completion(nil, nil, .invalidURL); return
            return .failure(.invalidURL)
        }
        return .success(url)
    }
}

struct Endpoints_Values {
    let apiScript = "api_v3.php"
    let latinDomain = "https://lat.rtrs.tv/_api/"
    let cyrilDomain = "https://www.rtrs.tv/_api/"
    var bannerUrl = "http://tv.rs.sr/_api/api.php?service=banner"
    var liveRadioUrl = "rtsp://radio.rtrs.tv:1935/radio/live"
    var live_mobileUrl = "rtsp://mobile.rtrs.tv:1935/tv/live"
}
