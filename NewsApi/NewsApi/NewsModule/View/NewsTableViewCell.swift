//
//  NewsTableViewCell.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    var controller: NewsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Установка значений в ячейку
    public func setDataToCell(title: String, status: Bool?, imageData: Data?, controller: NewsViewController) {
        self.controller = controller
        self.titleLabel.text = title
        
        if status == false {
            self.statusLabel.text = "not viewed"
        } else {
            self.statusLabel.text = "viewed"
        }
        
        if imageData != nil {
            self.newsImageView.image = UIImage(data: imageData!)
        } else {
            self.newsImageView.image = UIImage(named: "background")
        }
    }
}

