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
    private var holdingViewController: UIViewController?

    func addPanGesture(toView view : UIView) {
        self.sideMenuManager.addPanGestureToPresent(toView: view)
    }
    
    func addLeftController(_ vc:SideMenuNavigationController) {
        self.sideMenuManager.leftMenuNavigationController = vc
    }
    
    func create(with rootViewController: UIViewController) {
        let menuLeftNavigationController = SideMenuNavigationController(rootViewController: rootViewController)
        menuLeftNavigationController.sideMenuDelegate = self
        sideMenuManager.apply() {
            $0.leftMenuNavigationController = menuLeftNavigationController
            $0.menuFadeStatusBar = false
            $0.menuPresentMode = .menuSlideIn
        }
    }
    
    func closedMenu() {
        if isMenuShown {
            if let hvc = holdingViewController {
                hvc.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("No presenting view controller")
            }
        } else {
                debugPrint("Menu not presented")
        }

    }
    
    func toggleMenu(in vc: UIViewController) {
        if isMenuShown {
            if let hvc = holdingViewController {
                hvc.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("Weird error")
            }
        } else {
            vc.show(sideMenuManager.leftMenuNavigationController!, sender: self)
            holdingViewController = vc
        }

    }
}

extension LeftMenuService: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        // print("SideMenu Appearing! (animated: \(animated))")
        isMenuShown = true
        
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        // print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        // print("SideMenu Disappearing! (animated: \(animated))")
        isMenuShown = false
        
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        // print("SideMenu Disappeared! (animated: \(animated))")
        isMenuShown = false
    }
    
}
