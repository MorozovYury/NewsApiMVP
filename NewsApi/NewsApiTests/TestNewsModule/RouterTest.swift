//
//  RouterTest.swift
//  NewsApiTests
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import XCTest
@testable import NewsApi

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: true)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navContr = MockNavigationController()
    let assebly = AssemblyModules()

    override func setUp() {
        router = Router(navigarionController: navContr, assembly: assebly)
    }

    override func tearDown() {
        router = nil
    }
    
    func testRouter() {
        router.showDetailNewsController(news: nil)
        let detailVC = navContr.presentedVC
        
        XCTAssertTrue(detailVC is DetailNewsViewController)
    }
}
