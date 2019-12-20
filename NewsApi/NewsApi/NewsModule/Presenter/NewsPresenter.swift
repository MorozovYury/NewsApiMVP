//
//  NewsPresenter.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import Foundation

protocol NewsViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol NewsViewPresenterProtocol: class {
    init(view: NewsViewProtocol, netWorkService: NetWorkServiceProtocol, router: RouterProtocol)
    func getNews()
    func getImagesForNews()
    var articles: [Articles]? { get set }
    func tapOnTheArticle(news: Articles?)
    func searchArticle(searchedText: String)
}

class NewsPresenter: NewsViewPresenterProtocol {
    weak var view: NewsViewProtocol?
    let netWorkService: NetWorkServiceProtocol!
    var router: RouterProtocol?
    var articles: [Articles]?
    
    required init(view: NewsViewProtocol, netWorkService: NetWorkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.netWorkService = netWorkService
        self.router = router
        getNews()
    }
    
    func getNews() {
        netWorkService.getNews { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.articles = articles
                    self.getImagesForNews()
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getImagesForNews() {
        guard let article = articles else { return }
        self.articles?.removeAll()
        for var url in article {
            guard let imageURL = url.urlToImage else { return }
            netWorkService.fetchImage(newsImageURL: imageURL) { [weak self] result in
                switch result {
                case .success(let data):
                    url.imageData = data
                    self?.articles?.append(url)
                    self?.view?.success()
                case .failure(let error):
                    self?.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheArticle(news: Articles?) {
        router?.showDetailNewsController(news: news)
    }
    
    func searchArticle(searchedText: String) {
        let searchedNews = articles?.filter({ (article: Articles) -> Bool in
            if article.title.lowercased().contains(searchedText.lowercased()) {
                return true
            }
            return false
        })
        articles = searchedNews
        self.view?.success()
    }
}

