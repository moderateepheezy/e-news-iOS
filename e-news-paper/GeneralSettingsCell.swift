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
    
    
    @IBAction func changeLanguageTapped(_ sender: Any) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
