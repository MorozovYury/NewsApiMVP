//
//  NewsModel.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import Foundation

struct NewsModel: Codable {
    var status: String
    var code: String?
    var message: String?
    var articles: [Articles]?
}

struct Articles: Codable {
    var urlToImage: URL?
    var imageData: Data?
    var publishedAt: String
    var title: String
    var description: String
    var url: URL
    var status: Bool? = false
}
