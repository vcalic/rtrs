//
//  AppCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 3/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator  {
    
    private var window: UIWindow?
    private var coordinators: Coordinators = Coordinators()
    private var apiService: APIService!
    private var routerService: RouterService!
    private var navigationController: UINavigationController!
    private var articleLoader: ArticleLoader!
    private var inTransition = false
    private let menuCoordinator: MenuCoordinator
    
    init(with window: UIWindow?) {
        self.window = window
        self.apiService = APIService()
        self.menuCoordinator = MenuCoordinator(apiService: apiService)
    }
    
    func start(completion: CoordinatorBlock?) {
        routerService = RouterService(coordinator: self)
        
        if let navigationController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainNavigation") as? UINavigationController {
            self.navigationController = navigationController
            
            let homeViewController = HomeViewController.make(with: apiService, delegate:self)
            navigationController.viewControllers = [homeViewController]
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            menuCoordinator.start(completion: nil)
            completion?(navigationController)
        } else {
            fatalError("Could not initialize app")
        }
    }
}

extension AppCoordinator {
    func openSafari(with url: URL) {
        debugPrint("Not implemented yet. URL to open \(url)")
    }
    
    func show(_ viewController: UIViewController) {
        navigationController.show(viewController, sender: self)
    }
}
extension AppCoordinator: HomeViewControllerDelegate {
    func didSelect(article: ArticleInfo, in: HomeViewController) {
        if inTransition == true {
            return
        }
        inTransition = true
        let id = Int(article.id)!
        articleLoader = try! ArticleLoader(apiService: apiService, articleId: id)
        let vc = ArticleViewController.make(with: articleLoader, delegate: self)
        navigationController.show(vc, sender: self)
        inTransition = false
    }
    
    func openArticle(id: Int) {
        articleLoader = try! ArticleLoader(apiService: apiService, articleId: id)
        let vc = ArticleViewController.make(with: articleLoader, delegate: self)
        navigationController.show(vc, sender: self)
    }
}
extension AppCoordinator: ArticleViewControllerDelegate {
    func didLoad(_ articleViewController: ArticleViewController) {
        articleLoader.start()
    }
    
    func shouldAllow(url: URL) -> Bool {
        route(for: url)
        return false
    }
}

//MARK: - Router
extension AppCoordinator {
    func route(for url: URL) {
        debugPrint("Clicked on URL: \(url)")
        if url.host == "www.rtrs.tv" || url.host == "lat.rtrs.tv" {
            if let queryDictionary = url.queryDictionary,
                let idString = queryDictionary["id"],
                let id = Int(idString)
            {
                openArticle(id: id)
            }
        } else {
            openSafari(with: url)
        }
    }
}

