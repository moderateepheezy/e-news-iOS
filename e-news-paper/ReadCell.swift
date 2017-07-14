//
//  ReadCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ReadCell: UITableViewCell {
    
    var vendor: NewsPaper?
    var news: News? {
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
            
            if let vendorId = news?.newspaper_id{
                
                AppFirRef.newspaperRef.child(vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    let vendor = NewsPaper(value: value, vendorKey: snapshot.key)
                    self.vendorNameLabel.text = vendor.paper_name
                    self.vendor = vendor
                })
            }
        }
    }
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var vendorNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
