//
//  MenuCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

final class MenuCoordinator: Coordinator {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func start(completion: CoordinatorBlock?) {
        debugPrint("Started menu")
        //completion?(navigationController)
        apiService.menu { (result) in
            debugPrint("FromCoordinator: \(result)")
        }
    }
}
