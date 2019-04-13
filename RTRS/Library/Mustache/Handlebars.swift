//
//  Handlebars.swift
//  RTRS
//
//  Created by Vlada Calic on 3/2/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation
import JavaScriptCore


struct Handlebars {
    
    private let handleBars: URL
    private let main: URL
    private let context: JSContext
    private let htmlTemplate: String
    private var templates: [TemplateType:String]!
    
    init() throws {
        if let _url = Bundle.main.url(forResource: "handlebars", withExtension: "js") {
            handleBars = _url

        } else {
            throw AppError.missingMustache
        }
        
        if let _url = Bundle.main.url(forResource: "main", withExtension: "js") {
            main = _url
        }   else {
                throw AppError.missingMain
        }

        if let htmlUrl = Bundle.main.url(forResource: "template", withExtension: "html"),
            let html = try? String(contentsOf:htmlUrl) {
            htmlTemplate = html
        } else {
            throw AppError.missingMain
        }

        context = JSContext()!
        context.exceptionHandler = { context, exception in
            /* if let _exception = exception, let message = _exception.toString() {
             print(message)
             } */
            do {
                let ex = try exception.or(MError())
                let mess = try ex.toString().or(MError())
                debugPrint("JSContext exception message: \(mess)")
            } catch (let error) {
                debugPrint("JSContext exception: \(error)")
            }
        }
        
        do {
            context.evaluateScript(try String(contentsOf: handleBars), withSourceURL: handleBars)
            context.evaluateScript(try String(contentsOf: main), withSourceURL: main)
            
            /* add debugPrint and map console.log to it */
            context.evaluateScript("var console = { log: function(message) { debugPrint(message) } }")
            let consoleLog: @convention(block) (String) -> Void = { message in
                debugPrint("console.log: " + message)
            }
            context.setObject(unsafeBitCast(consoleLog, to: AnyObject.self),
                              forKeyedSubscript: "debugPrint" as (NSCopying & NSObjectProtocol)?)
            
            templates = [:]
            templates[.title] = try TemplateType.title.getContent()
            templates[.lead] = try TemplateType.lead.getContent()
            templates[.body] = try TemplateType.body.getContent()
            templates[.timeSource] = try TemplateType.timeSource.getContent()
            templates[.video] = try TemplateType.video.getContent()
            templates[.article] = try TemplateType.article.getContent()
            templates[.layout] = try TemplateType.layout.getContent()
            
        } catch (let err) {
            throw err
        }
    }
    
    var templatesJson: String  {
        
        var tmpTemplates: [String:String] = [:]
        for (key, value) in templates {
            tmpTemplates[key.rawValue] = value
        }
        
        if let jsondata = try? JSONSerialization.data(withJSONObject: tmpTemplates as Any, options: .prettyPrinted),
            let jsontext = String(data: jsondata, encoding: .utf8) {
            return jsontext
        } else {
            return ""
        }
    }
    
    func perform(article: Article) throws -> String {
        if templates == nil {
            throw AppError.missingTemplate
        }
        guard let createStencil = context.objectForKeyedSubscript("createStencil") else { debugPrint("No createStencil"); throw(AppError.missingTemplate) }
        
        if let jsondata = try? JSONSerialization.data(withJSONObject: article.getData() as Any,
                                                      options: .prettyPrinted),
            let jsontext = String(data: jsondata, encoding: .utf8) {
            if let stencil = createStencil.call(withArguments: [jsontext, templatesJson])!.toString() {
                return stencil
            } else {
                throw(AppError.handlebarError)
            }
        } else {
            throw(AppError.missingTemplate)
        }
    }

  
}

func getData() -> [String:String] {
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
    ];
    return data
}
