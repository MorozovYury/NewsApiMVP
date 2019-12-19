//
//  NewsPresenterNews.swift
//  NewsApiTests
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import XCTest
@testable import NewsApi

class MockView: NewsViewProtocol {
    func success() {
    }
    func failure(error: Error) {
    }
}

class MockNetWorkService: NetWorkServiceProtocol {
    var news: [Articles]!
    init() {
    }
    convenience init (news: [Articles]?) {
        self.init()
        self.news = news
    }
    func getNews(completion: @escaping (Result<[Articles]?, Error>) -> ()) {
        if let news = news {
            completion(.success(news))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func fetchImage(newsImageURL: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
}

class NewsPresenterNews: XCTestCase {
    
    var view: MockView!
    var presenter: NewsPresenter!
    var netWorkService: NetWorkServiceProtocol!
    var router: RouterProtocol!
    var articles = [Articles]()
    
    override func setUp() {
        view = MockView()
        let navContr = UINavigationController()
        let assebly = AssemblyModules()
        router = Router(navigarionController: navContr, assembly: assebly)
    }
    
    override func tearDown() {
        view = nil
        netWorkService = nil
        presenter = nil
    }
    
    func testGetSuccessNews() {
        guard let url = URL(string: "bazbar") else { return }
        let article = Articles(urlToImage: nil, imageData: nil, publishedAt: "Foo", title: "Baz", description: "Bar", url: url, status: false)
        articles.append(article)
        
        view = MockView()
        netWorkService = MockNetWorkService(news: [article])
        presenter = NewsPresenter(view: view, netWorkService: netWorkService, router: router)
        
        var catchArticle: [Articles]?
        
        netWorkService.getNews { result in
            switch result {
            case .success(let article):
                catchArticle = article
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchArticle?.count, 0)
        XCTAssertEqual(catchArticle?.count, articles.count)
    }
    
    func testGetFailureNews() {
        guard let url = URL(string: "bazbar") else { return }
        let article = Articles(urlToImage: nil, imageData: nil, publishedAt: "Foo", title: "Baz", description: "Bar", url: url, status: false)
        articles.append(article)
        
        view = MockView()
        netWorkService = MockNetWorkService()
        presenter = NewsPresenter(view: view, netWorkService: netWorkService, router: router)
        
        var catchError: Error?
        
        netWorkService.getNews { result in
            switch result {
            case .success(let _):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
    
}
