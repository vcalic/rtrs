//
//  HomeViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 2/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController, StoryboardLoadable {

    static var storyboardName = "Main"
    
    private var dataSource: [ArticleInfo] = []
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: HomeViewControllerDelegate?
    var apiService:APIService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        loadData()
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .action,
                                         target: self,
                                         action: #selector(openMenu))
        navigationItem.leftBarButtonItem = leftButton
    }
    @objc func openMenu(_ sender: Any) {
        delegate?.toggleMenu(in: self)
    }
    
    func loadData() {
        apiService.homePage(id: -1, count: 50) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.dataSource = articles.news
                self?.tableView.reloadData()
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(article: dataSource[indexPath.row], in: self)
    }
}

extension HomeViewController {
    class func make(with apiService: APIService, delegate:HomeViewControllerDelegate) -> HomeViewController {
        let vc = HomeViewController.instantiate()
        vc.delegate = delegate
        vc.apiService = apiService
        return vc
    }

}
protocol HomeViewControllerDelegate: class {
    func didSelect(article: ArticleInfo, in: HomeViewController)
    func toggleMenu(in homeViewController: HomeViewController)
}
