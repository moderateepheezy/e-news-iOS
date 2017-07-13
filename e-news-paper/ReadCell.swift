//
//  ReadCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ReadCell: UITableViewCell {

    var news: News? {
        didSet{
            if let newTitle = news?.caption{
                //newsTitleLabel.text = newTitle
            }
            
            if let vendorId = news?.newspaper_id{
                
                AppFirRef.newspaperRef.child(vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    let vendor = NewsPaper(value: value, vendorKey: snapshot.key)
                    self.vendorNameLabel.text = vendor.paper_name
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
