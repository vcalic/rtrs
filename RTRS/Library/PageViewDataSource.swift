//
//  PageViewDataSource.swift
//  RTRS
//
//  Created by Vlada Calic on 6/17/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

public typealias ConfigurePageBlock = (_ cell: Any, _ object: Any, _ index: Int) -> Void
typealias InstantiateViewControllerBlock = () -> PageViewContent

@objc protocol PageViewContent {
    var index: Int { get set }
    var topView: UIView? { get set }
}

@objc class PageViewDataSource: NSObject {
    // @property (nonatomic, copy) NSArray *data;
    // @property (nonatomic, assign, readonly) NSUInteger index;

    var data: [Any] = []
    var index: Int {
        return currentIndex
    }
    
    private var indexBefore: Int?
    private var indexNext: Int?
    private var indexCurrent: Int?
    private var count: Int?
    
    private var containerViewController: UIViewController!
    private var containerView: UIView!
    private var pageViewController: UIPageViewController!
    private var currentIndex: Int!
    private var configurePageBlock: ConfigurePageBlock?
    private var instantiateViewControllerBlock: InstantiateViewControllerBlock?
    
    //MARK: - Code
    @objc func setupPageViewController(_ pageViewController: UIPageViewController,
                                 in containerView: UIView,
                                 for viewController: UIViewController,
                                 configureWith configurePageBlock: @escaping ConfigurePageBlock,
                                 instantiateWith instantiateViewControllerBlock: @escaping InstantiateViewControllerBlock)
    {
        self.pageViewController = pageViewController
        self.containerView = containerView
        self.containerViewController = viewController
        self.configurePageBlock = configurePageBlock
        self.instantiateViewControllerBlock = instantiateViewControllerBlock
        setup()
    }
    
    func viewControllerAt(index: Int) -> PageViewContent {
        guard let block = instantiateViewControllerBlock else { fatalError("You didn't instantiate the controller!") }
        guard let configure = configurePageBlock else { fatalError("No configurePageBlock!!!") }

        let retval = block()
        let view = retval.topView
        if view == nil || data.count == 0 || index > data.count {
            return retval
        }
        
        retval.index = index
        let content = data[index]
        configure(retval, content, index)
        return retval
    }
    
    func goto(page: Int) {
        debugPrint("Goto called")
        guard let startingViewController = viewControllerAt(index: page) as? UIViewController else { fatalError("NoStartingViewController") }
        
        pageViewController.setViewControllers([startingViewController],
                                              direction: UIPageViewController.NavigationDirection.forward,
                                              animated: true,
                                              completion: nil)
        currentIndex = page
    }
    
    private func setup() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        //TODO: Fixthis
        let startingViewController = viewControllerAt(index: 0) as! UIViewController
        let viewControllers = [startingViewController]

        pageViewController.setViewControllers(viewControllers,
                                              direction: UIPageViewController.NavigationDirection.forward,
                                              animated: true,
                                              completion: nil)
        
        pageViewController.view.frame = containerView.bounds
        containerViewController.addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: containerViewController)
        currentIndex = 0
    }
}
extension PageViewDataSource: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContentVC = viewController as? PageViewContent else { fatalError("Before Fatal!!!") }
        
        var localIndex = pageContentVC.index
        if localIndex == NSNotFound || localIndex == 0 {
            return nil
        }
        localIndex = localIndex - 1
        indexBefore = localIndex

        return viewControllerAt(index: localIndex) as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContentVC = viewController as? PageViewContent else { fatalError("After Fatal!!!") }
        
        var localIndex = pageContentVC.index
        if localIndex == NSNotFound {
            return nil
        }
        localIndex += 1
        indexNext = localIndex
        if localIndex == data.count {
            return nil
        }

        return viewControllerAt(index: localIndex) as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let current = pageViewController.viewControllers?[0] as? PageViewContent else { fatalError("Unknown error") }
        if completed {
            currentIndex = current.index
        }
    }
}

