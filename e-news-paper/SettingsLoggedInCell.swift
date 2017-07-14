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
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        
        usernameLabel.text = Localization("usernameText")
        userEmailLabel.text = Localization("emailText")
        userPhoneNumberLabel.text = Localization("phoneText")
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            usernameLabel.text = Localization("usernameText")
            userEmailLabel.text = Localization("emailText")
            userPhoneNumberLabel.text = Localization("phoneText")
        }
    }
    
    // MARK: - Memory management
    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotificationLanguageChanged, object: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
