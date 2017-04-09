//
//  FancyView.swift
//  devslopes-social
//
//  Created by Jess Rascal on 24/07/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit

class FancyView: UIView {
    
    let SHADOW_GRAY: CGFloat = 120.0 / 255.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }

}
