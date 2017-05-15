//
//  SettingsLoggedInCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/15/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class SettingsLoggedInCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
