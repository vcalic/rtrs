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
    
    func perform(article: Article, alphabet: Alphabet = .latin) throws -> String {
        if templates == nil {
            throw AppError.missingTemplate
        }
        guard let createStencil = context.objectForKeyedSubscript("createStencil") else { debugPrint("No createStencil"); throw(AppError.missingTemplate) }
        
        if let jsondata = try? JSONSerialization.data(withJSONObject: article.getData(alphabet: alphabet) as Any,
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
    
    func prepare(article: Article) {
        
    }
}

private extension Article {
    func getData(alphabet: Alphabet) -> [String:String] {
        let retval:[String:String] = [
            "date": publishDate ?? "",
            "time": "",
            "source_label": alphabet.source,
            "source": agency ?? "",
            "title": title.decodeHTMLEntities,
            "lead": introText.decodeHTMLEntities,
            "body": text.decodeHTMLEntities,
            "video_url": videoUrl ?? "",
            "video_info": videoName ?? "",
            "poster_url": largeImageUrl ?? ""
        ]
        debugPrint(retval)
        return retval
    }
}

