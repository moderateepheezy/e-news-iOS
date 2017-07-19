//
//  CommentCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit


class CommentCell: UITableViewCell {
    
    
    var comment: Comment? {
        didSet{
            
            let url = URL(string: (comment?.userImage)!)
            userProfileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "pp"))
            usernameLabel.text = comment?.username
            commentLabel.text = comment?.text
            
            let epocTime = TimeInterval((comment?.timeSent)!)
            
            print(epocTime)
            
            let date = Date(timeIntervalSince1970: epocTime / 1000)
            print(date)
            
            commentTimeLabel.text = timeAgoSinceDate(date)
        }
    }
    
    
    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        userProfileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
