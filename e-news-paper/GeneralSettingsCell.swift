//
//  GeneralSettingsCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/15/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class GeneralSettingsCell: UITableViewCell {
    
    @IBOutlet weak var generalNotifSwitch: UISwitch!
    
    
    @IBOutlet weak var signoutSwitch: UISwitch!
    
    
    @IBOutlet weak var unsubscribeSwitch: UISwitch!
    
    
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var generalNotifLabel: UILabel!
    @IBOutlet weak var signoutLabel: UILabel!
    @IBOutlet weak var unSubscribeAllLabel: UILabel!
    
    
    
    @IBAction func changeLanguageTapped(_ sender: Any) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        
    changeLanguageButton.setTitle(Localization("changeLanguaeText"), for: .normal)
        
        generalLabel.text = Localization("generalText")
        generalNotifLabel.text = Localization("generalNotifText")
        signoutLabel.text = Localization("signoutText")
        unSubscribeAllLabel.text = Localization("unSubscribeAllText")
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            generalLabel.text = Localization("generalText")
            generalNotifLabel.text = Localization("generalNotifText")
            signoutLabel.text = Localization("signoutText")
            unSubscribeAllLabel.text = Localization("unSubscribeAllText")
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
