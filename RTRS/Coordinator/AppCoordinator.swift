//
//  AppCoordinator.swift
//  RTRS
//
//  Created by Vlada Calic on 3/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import SideMenu
import UIKit

final class AppCoordinator: Coordinator {
  var parent: Coordinator?
  private var window: UIWindow?
  private var coordinators = Coordinators()
  private var apiService: APIService!
  private var articleService: ArticleService!
  private var routerService: RouterService!
  private var navigationController: UINavigationController!
  private var articleLoader: ArticleLoader!
  private var inTransition = false
  private let menuCoordinator: MenuCoordinator
  private let mainCoordinator: MainCoordinator
  private let menuService: LeftMenuService

  init(with window: UIWindow?) {
    self.window = window
    self.apiService = APIService()
    self.menuService = LeftMenuService()
    do {
      self.articleService = try ArticleService(apiService: apiService)
    } catch {
      fatalError("Could not initialize articleService \(error)")
    }
    self.menuCoordinator = MenuCoordinator(apiService: apiService, menuService: menuService)
    self.mainCoordinator = MainCoordinator(apiService: apiService, articleService: articleService)
  }

  func start(completion: CoordinatorBlock?) {
    routerService = RouterService(coordinator: self)
    menuCoordinator.parent = self

    if let navigationController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainNavigation") as? UINavigationController {
      self.navigationController = navigationController

      let homeViewController = HomeViewController.make(with: apiService, delegate: self)
      navigationController.viewControllers = [homeViewController]

      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()

      menuCoordinator.start { vc in
        self.menuService.apply {
          $0.create(with: vc)
          $0.addPanGesture(toView: self.navigationController.navigationBar)
        }
        completion?(navigationController)
      }

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
  func toggleMenu(in homeViewController: HomeViewController) {
    menuService.toggleMenu(in: navigationController)
  }

  func didSelect(articles: [ArticleInfo], selected: Int, in: HomeViewController) {
    if inTransition == true {
      return
    }
    inTransition = true
    // articleOpen(article: articles[selected])
    let articlePages = ArticleSwipeViewController()
    articlePages.articles = articles
    articlePages.indexPath = IndexPath(row: selected, section: 0)
    articlePages.delegate = self
    navigationController.show(articlePages, sender: self)
    inTransition = false
  }

  func openArticle(id: Int) {
    do {
      let articleLoader = try ArticleLoader(articleService: articleService, articleId: id)
      let vc = ArticleViewController.make(with: articleLoader, delegate: self)
      navigationController.present(vc, animated: true)
    } catch {
      debugPrint("Could not openArticle: \(error)")
    }
  }

  private func articleOpen(article: ArticleInfo) {
    let id = Int(article.id)!
    articleLoader = try! ArticleLoader(articleService: articleService, articleId: id)
    let vc = ArticleViewController.make(with: articleLoader, delegate: self)
    vc.setup()
    navigationController.show(vc, sender: self)
  }
}

extension AppCoordinator: ArticleSwipeViewControllerDelegate {
  func configure(articleViewController: ArticleViewController, info: ArticleInfo, index: Int) {
    if let id = Int(info.id),
       let articleLoader = try? ArticleLoader(articleService: articleService, articleId: id)
    {
      articleViewController.articleLoader = articleLoader
      articleViewController.setup()
    } else {
      fatalError("Die in configure")
    }
  }

  func makeArticleViewController() -> ArticleViewController {
    let vc = ArticleViewController.make(withDelegate: self)
    return vc
  }
}

extension AppCoordinator: ArticleViewControllerDelegate {
  func didLoad(_ articleViewController: ArticleViewController, articleLoader: ArticleLoader) {
    debugPrint("Did load")
    articleLoader.start()
  }

  func shouldAllow(url: URL) -> Bool {
    route(for: url) // Call Router Service instead
    return false
  }
}

// MARK: - Router

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
