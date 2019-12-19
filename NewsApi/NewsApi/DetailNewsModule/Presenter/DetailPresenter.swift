//
//  DetailPresenter.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func setNews(news: Articles?)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, netWorkService: NetWorkServiceProtocol, router: RouterProtocol, news: Articles?)
    func setNews()

}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let netWorkService: NetWorkServiceProtocol!
    var router: RouterProtocol?
    var article: Articles?
    
    required init(view: DetailViewProtocol, netWorkService: NetWorkServiceProtocol, router: RouterProtocol, news: Articles?) {
        self.view = view
        self.netWorkService = netWorkService
        self.router = router
        self.article = news
    }
    
    public func setNews() {
        guard let art = article else { return }
        article?.publishedAt = dateFromISOstringToddMMyyyy(date: art.publishedAt)
        article?.status = true
        self.view?.setNews(news: article)
    }
    
    private func dateFromISOstringToddMMyyyy(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let newDate = dateFormatter.date(from: date) else {return ""}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let stringDate = dateFormatter.string(from: newDate)
        return stringDate
    }
}
