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

extension Article {
    func getData() -> [String:String] {
        let retval:[String:String] = [
            "date": publishDate ?? "",
            "time": "",
            "source_label": "Izvor",
            "source": agency ?? "",
            "title": title,
            "lead": introText,
            "body": text,
            "video_url": videoUrl ?? "",
            "video_info": videoName ?? "",
            "poster_url": largeImageUrl ?? ""
        ]
        return retval
    
        /*
        
        let data = [
            "date": "30/03/2019",
            "time": "16:48 ⇒ 20:38",
            "source_label": "Izvor",
            "source": "RTRS",
            "title": "U Hercegovini aktivno 10 požara",
            "lead": " Na području Hercegovine aktivno je desetak požara u niskom rastinju, najviše na području Bileće. Najveća linija\n" +
                "        je u području sela Baljci, gdje se požar proširio sa teritorije susjedne Crne Gore. Tokom dana, u nekoliko\n" +
            "        bilećkih sela izbili su novi požari, a nastali su namjernim paljenjem korova i sasušene trave.",
            "body": "<p>\n" +
                "        Požari u niskom rastinju, potpomognuti vjetrom, traju već deset dana. Opožarena površina je velika, ali nigdje\n" +
                "        nisu ugrožene kuće i imovina mještana. Samo na području Bijele Rudine, od jutros je izbilo nekoliko manjih\n" +
                "        požara.<br>\n" +
                "        <br>\n" +
                "        - Ne bi trebalo da dođe do kuća. Sve je okolo izgorjelo. Nismo zvali vatrogasce, sam gasim požar, vjerujem da će\n" +
                "        neko i doći u pomoć - kaže Nemanja Milićević iz&nbsp;sela Bijela Rudina.\n" +
                "      </p>\n" +
                "      <p>\n" +
                "        Požarna linija, koja se mjeri kilometrima, u nepristupačnom terenu je na području sela Baljci. Vatra je stigla\n" +
                "        sa teritorije Crne Gore. U području Korita, vatrogasci su danas intervenisali u blizini kuća. Gori i na nekoliko\n" +
                "        mjesta zapadno od Bileće.<br>\n" +
                "        <br>\n" +
                "        - Kada je isušen teren i kada nema padavima, pojave se požari, naročito u ovom periodu proljeća, kada ljudi\n" +
                "        čiste posjede, pale, i požar se širi nekontrolisano - tvrdi&nbsp;Radomir Radmilović, komandir TVЈ Bileća.\n" +
                "      </p>\n" +
                "      <p>\n" +
                "        Radmilović nema informaciju da je neko odgovarao za namjerne paljevine. Zbog velikog broja požara, vozila i\n" +
                "        ljudstvo su na terenu. O ovom problemu i pripremi za narednu sezonu, sa vatrogascima i predstavnicima Civilne\n" +
                "        zaštite, razgovarao je zamjenik direktora Republičke uprave Civilne zaštite. Regionalni sastanak trebalo bi da\n" +
                "        bude održan krajem aprila.\n" +
                "      </p>\n" +
                "      <p>\n" +
                "        - Kada ćemo uključiti sve vatrogasne jedinice, službe Civilne zaštite, šumska gazdinstva, da vidimo šta je\n" +
                "        urađeno po pitanju mjera koje je donijela Vlada Republike Srpske, da vidimo da li su šumska gazdinstva uradila\n" +
                "        lokalne i šumske puteve&nbsp;- ističe&nbsp;Darko Ljuboje, zamjenik direktor Republičke uprave Civilne\n" +
                "        zaštite.<br>\n" +
                "        <br>\n" +
                "        Ljuboje je rekao da nije potpuno definisan način koordinacije sa Ministarstvom odbrane i Oružanim snagama BiH, i\n" +
                "        upotreba ljudstva i tehnike u gašenju požara.\n" +
                "      </p>\n" +
                "      <p>\n" +
                "        - Tu ćemo morati riješiti saradnju na način da direktno uspostavimo saradnju sa OS, ne da izbjegnemo, nego da\n" +
                "        ubrzamo pomoć građanima na terenu - dodaje Ljuboje.\n" +
                "      </p>\n" +
                "      <p>\n" +
                "        Usvajanjem novog zakona o zaštiti od požara, rekao je Ljuboje, više novca trebalo bi da ide Vatrogasnom savezu i\n" +
                "        vatrogasnim jedinicama. Zbog čestih požara, dodatno bi trebalo da budu opremljene vatrogasne jedinice u\n" +
                "        Hercegovini.\n" +
            "      </p>",
            "video_url": "https://arh3.rtrs.tv/arhiva/2019/03/30/tvclip035047.mp4",
            "poster_url": "https://www.rtrs.tv/_FOTO/nwz/_an/1370/137065.jpg",
            "video_info": "Bileća: Požari pod kontrolom",
        ]; */
        // return data
    }

}
