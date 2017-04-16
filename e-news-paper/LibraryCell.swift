//
//  LibraryCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class LibraryCell: UICollectionViewCell {

    @IBOutlet weak var vendorImage: UIImageView!
    
    @IBOutlet weak var vendorName: UILabel!
    
    
    var set: NewsPaper?{
        didSet{
            vendorName.text = set?.paper_name
        }
    }

}
