//
//  LoggedInCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class LoggedInCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
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
