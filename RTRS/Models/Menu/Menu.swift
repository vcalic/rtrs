//
//  Menu.swift
//  RTRS
//
//  Created by Vlada Calic on 3/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

struct Menu: Codable {
    public var id: Int
    public var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "CategoryID"
        case name = "Name"
        
    }
}
