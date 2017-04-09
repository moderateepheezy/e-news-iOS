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
    
    var cost: String?
    var logo: String?
    var method: String?
    var paper_name: String?
    var validity: String?
    var vendorKey: String?
    
    init(value: [String: Any], vendorKey: String) {
        self.vendorKey = vendorKey
        self.cost = value["cost"] as? String
        self.logo = value["logo"] as? String
        self.method = value["method"] as? String
        self.paper_name = value["paper_name"] as? String
        self.validity = value["validity"] as? String
    }
}
