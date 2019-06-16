//
//  MainCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 4/22/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

final class MainCoordinator: Coordinator {
    var parent: Coordinator?
    private let apiService:APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }

    func start(completion: CoordinatorBlock?) {
        
    }
    
    
    
    
}
