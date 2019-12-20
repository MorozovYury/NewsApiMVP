//
//  NewsViewController.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var presenter: NewsPresenter!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        newsTableView.register(nib, forCellReuseIdentifier: "NewsTableViewCell")
        newsTableView.dataSource = self
        newsTableView.delegate = self
        setSearchController()
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension NewsViewController: NewsViewProtocol {
    func success() {
        newsTableView.reloadData()
    }
    
    func failure(error: Error) {
        let alert = UIAlertController(title: "Внимание!", message: "Произошла ошибка: \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        let cellData = presenter.articles?[indexPath.row]
        cell.setDataToCell(title: cellData?.title ?? "Title", status: cellData?.status ?? false, imageData: cellData?.imageData ?? Data(), controller: self)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.articles?[indexPath.row].status = true
        newsTableView.reloadData()
        presenter.tapOnTheArticle(news: presenter.articles?[indexPath.row])
    }
}

extension NewsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.getNews()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            if searchText.count > 0 {
                presenter.searchArticle(searchedText: searchText)
            }
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
    }
}

