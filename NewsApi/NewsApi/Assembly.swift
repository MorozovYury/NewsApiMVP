//
//  Assembly.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import UIKit

protocol AssemblyProtocol {
    func createNewsModule(router: RouterProtocol) -> UIViewController
    func createDetailNewsModule(article: Articles?, router: RouterProtocol) -> UIViewController
}

class AssemblyModules: AssemblyProtocol {
    
    let view = NewsViewController()
    let netWorkService = NetWorkService()
    
    func createNewsModule(router: RouterProtocol) -> UIViewController {
        let view = NewsViewController()
        let netWorkService = NetWorkService()
        let presenter = NewsPresenter(view: view, netWorkService: netWorkService, router: router)
        view.presenter = presenter
        
        return view
    }
    func createDetailNewsModule(article: Articles?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let netWorkService = NetWorkService()
        let presenter = DetailPresenter(view: view, netWorkService: netWorkService, router: router, news: article)
        view.presenter = presenter
        
        return view
    }
}
