//
//  Router.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigarionController: UINavigationController? { get set }
    var assembly: AssemblyProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initViewController()
    func showDetailNewsController(news: Articles?)
}

class Router: RouterProtocol {
    var navigarionController: UINavigationController?
    var assembly: AssemblyProtocol?
    
    init(navigarionController: UINavigationController, assembly: AssemblyProtocol) {
        self.navigarionController = navigarionController
        self.assembly = assembly
    }
    
    func initViewController() {
        if let navController = navigarionController {
            guard let mainViewController = assembly?.createNewsModule(router: self) else { return }
            navigarionController?.viewControllers = [mainViewController]
        }
    }
    
    func showDetailNewsController(news: Articles?) {
        if let navController = navigarionController {
            guard let detailNewsViewController = assembly?.createDetailNewsModule(article: news, router: self) else { return }
            navigarionController?.pushViewController(detailNewsViewController, animated: true)
        }
    }
}
