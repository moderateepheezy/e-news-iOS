//
//  NewsListCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {
    
    var news: News?{
        didSet{
            newsTitleLabel.text = news?.caption
            
        }
    }
    
    @IBOutlet weak var newsImageView: UIImageView!

    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var vendorNameLabel: UILabel!
    
    @IBOutlet weak var numberOfCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
