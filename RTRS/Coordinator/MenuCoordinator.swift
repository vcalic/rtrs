//
//  MenuCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

final class MenuCoordinator: Coordinator {
    var parent: Coordinator?
    private let apiService: APIService
    private let menuService: LeftMenuService
    private var navigationController: UINavigationController!
    private var menuViewController: MenuViewController?

    init(apiService: APIService, menuService: LeftMenuService) {
        self.apiService = apiService
        self.menuService = menuService
    }
    
    func start(completion: CoordinatorBlock?) {
        debugPrint("Started menu")
        //completion?(navigationController)
        apiService.categories { (result) in
            debugPrint("FromCoordinator: \(result)")
        }

        menuViewController = MenuViewController.make()
        menuViewController!.delegate = self
        if let block = completion {
            block(menuViewController!)
        } else {
            fatalError("Couldn't initialize MenuCoordinator")
        }
    }
}

extension MenuCoordinator: MenuViewControllerDelegate {
    func didPressToggleMenu(_ vc: MenuViewController) {
        debugPrint("Did press toggle")
        menuService.closedMenu()
    }
}
