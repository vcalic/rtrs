//
//  LeftMenuService.swift
//  RTRS
//
//  Created by Vlada Calic on 4/15/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit
import SideMenu


final class LeftMenuService: Appliable {
    private let sideMenuManager: SideMenuManager = SideMenuManager()
    private var isMenuShown:Bool = false

    func addPanGesture(toView view : UIView) {
        self.sideMenuManager.menuAddPanGestureToPresent(toView: view)
    }
    
    func addLeftController(_ vc:UISideMenuNavigationController) {
        self.sideMenuManager.menuLeftNavigationController = vc
    }
    
    func create(with rootViewController: UIViewController) {
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: rootViewController)
        menuLeftNavigationController.sideMenuDelegate = self
        sideMenuManager.apply() {
            $0.menuLeftNavigationController = menuLeftNavigationController
            $0.menuFadeStatusBar = false
            $0.menuPresentMode = .menuSlideIn
        }
    }
    
    func toggleMenu(in vc: UIViewController) {
        if isMenuShown {
            vc.dismiss(animated: true, completion: nil)
        } else {
            vc.show(sideMenuManager.menuLeftNavigationController!, sender: self)
        }

    }
}

extension LeftMenuService: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
        isMenuShown = true
        
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
        isMenuShown = false
        
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
        isMenuShown = false
    }
    
}
