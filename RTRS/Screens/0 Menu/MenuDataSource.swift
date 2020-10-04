//
//  MenuDataSource.swift
//  RTRS
//
//  Created by Vlada Calic on 4/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation


enum AppSections {
    case tvlive, radiolive, news, tv, radio, video, audio, photo, rtrs, contact, about
}

extension AppSections {
    
    func name(for alphabet: Alphabet = .latin) -> String {
        switch self {
            
        case .tvlive:
            switch alphabet {
            case .latin:
                return "TV uživo"
            case .cyril:
                return "TV uživo"
            }
        case .radiolive:
            switch alphabet {
            case .latin:
                return "Radio uživo"
            case .cyril:
                return "Radio uživo"
            }

        case .news:
            switch alphabet {
            case .latin:
                return "Vijesti"
            case .cyril:
                return "Vijesti"
            }
            
        case .tv:
            switch alphabet {
            case .latin:
                return "TV uživo"
            case .cyril:
                return "TV uživo"
            }

        case .radio:
            switch alphabet {
            case .latin:
                return "Radio"
            case .cyril:
                return "Radio"
            }

        case .video:
            switch alphabet {
            case .latin:
                return "Video"
            case .cyril:
                return "Video"
            }

        case .audio:
            switch alphabet {
            case .latin:
                return "Audio"
            case .cyril:
                return "Audio"
            }
        case .photo:
            switch alphabet {
            case .latin:
                return "Foto"
            case .cyril:
                return "Foto"
            }
        
            case .rtrs:
            switch alphabet {
            case .latin:
                return "RTRS"
            case .cyril:
                return "RTRS"
            }
        case .contact:
            switch alphabet {
            case .latin:
                return "Kontakt"
            case .cyril:
                return "Kontakt"
            }
        case .about:
            switch alphabet {
            case .latin:
                return "O aplikaciji"
            case .cyril:
                return "O aplikaciji"
            }
    }
    }
}

struct SectionMenu {
    var id: Int
    var name: String
    var cyrName: String
    var photo: String?
}

extension SectionMenu {
    static func getSections() -> [SectionMenu] {
        return [
            SectionMenu(id: 1, name: "TV Uživo", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Radio uživo", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Vijesti", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "TV", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Radio", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Video", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Audio", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Foto", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "RTRS", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "Kontakt", cyrName: "", photo: nil),
            SectionMenu(id: 1, name: "O aplikaciji", cyrName: "", photo: nil),
        ]
    }
    
    static func generate() -> [AppSections] {
        return [
            .tvlive, .radiolive, .news, .tv, .radio, .video, .audio, .photo, .rtrs, .contact, .about
        ]
    }
}
