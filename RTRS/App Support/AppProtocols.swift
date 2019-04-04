//
//  AppProtocols.swift
//  RTRS
//
//  Created by Vlada Calic on 12/13/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import UIKit

protocol CellConfigurable where Self: UITableViewCell {
    associatedtype T
    static var identifier:String {get}
    static func register(tableView: UITableView)
    func configure(with object:T)
}

