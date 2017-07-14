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
            
            if Localization("English_en") == "Anglais" {
                if news?.caption.french != "" {
                    newsTitleLabel.text = news?.caption.french
                }else{
                    newsTitleLabel.text = news?.caption.english
                }
            }else{
                if news?.caption.english != "" {
                    newsTitleLabel.text = news?.caption.english
                }else{
                    newsTitleLabel.text = news?.caption.french
                }
            }
            
            if let created = news?.created_on {
                
                let epocTime = TimeInterval(created)
                
                let date = Date(timeIntervalSince1970: epocTime / 1000)
                print(date)
                
                
                timeAgoLabel.text = timeAgoSinceDate(date)
                
                
                getCommentsCount(key: (news?.newsKey)!, label: numberOfCommentLabel)
            }
        }
    }
    @IBOutlet weak var timeAgoLabel: UILabel!
    
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
    
    func getCommentsCount(key: String, label: UILabel){
        
        
        AppFirRef.commentsRef.child(key).observe(.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                label.text =  "\(snapshot.childrenCount)"
            }else{
                label.text = "0"
            }
            
        })
    }

}
