//
//  NewsPaper.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import UIKit

public class NewsPaper{
    
    var logo: String?
    var paper_name: String?
    var vendorKey: String?
    
    init(value: [String: Any], vendorKey: String) {
        self.vendorKey = vendorKey
        self.logo = value["logo"] as? String
        self.paper_name = value["paper_name"] as? String
    }
}
