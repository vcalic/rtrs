//
//  HomeViewController.swift
//  RTRS
//
//  Created by Vlada Calic on 2/13/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var dataSource: [ArticleInfo] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        HomeLoader().loadUser(withID: -1) { (result) in
            switch result {
            case .success(let list):
                debugPrint("Duz: \(list.news.count)")
            
            default:
                debugPrint("None")
            }
        }
    }
    
    func loadData() {
        let api = APIService()
        api.homePage(id: -1, count: 50) { [weak self] result in
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
        if let id = Int(dataSource[indexPath.row].id) {
            APIService().article(id: id) { [weak self] (result) in
                guard let article = try? result.get() else { debugPrint("Error"); return }
                let vc = ArticleViewController.make(with: article)
                self?.show(vc, sender: self)
            }
        } else {
            debugPrint("Nije int: \(dataSource[indexPath.row].id)")
        }
    }
}


class HomeLoader {
    
    typealias HomeHandler = (Result<ArticleList, AppError>) -> Void
    var placeholder = ""
    /* func loadUser(withID id:Int) -> Future<ArticleList> {
        
    } */
    
    func loadUser(withID id: Int, completionHandler: @escaping HomeHandler) {
        let url = Services.categoryArticles(id: -1, count: 30).value
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.placeholder = ""
            if let error = error {
                let appError = AppError(error: error)
                completionHandler(.failure(appError))
            } else {
                do {
                    // let user: User = try unbox(data: data ?? Data())
                    if let data = data {
                        let list = try ArticleList(with: data)
                        completionHandler(.success(list))
                    } else {
                        completionHandler(.failure(.generalError))
                    }
                    
                } catch {
                    completionHandler(.failure(AppError(error:error)))
                }
            }
        }
        
        task.resume()
    }

}
