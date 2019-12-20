//
//  DetailViewController.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var presenter: DetailPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article"
        presenter.setNews()
    }
}

extension DetailViewController: DetailViewProtocol {
    func setNews(news: Articles?) {
        if let imageData = news?.imageData {
            newsImageView.image = UIImage(data: (news?.imageData!)!)
        } else {
            newsImageView.image = UIImage(named: "background")
        }
        dateLabel.text = news?.publishedAt
        titleLabel.text = news?.title
        descriptionTextView.text = news?.description
        urlLabel.text = news?.url.absoluteString
    }
}
