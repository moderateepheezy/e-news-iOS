//
//  News.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import UIKit

public class News {
    
    var caption: String?
    var content: String?
    var created_on: CLong?
    var newspaper_id: String?
    var thumbnail: String?
    var newsKey: String?
    
    var fav: String?
    
    
    init(value: [String:  Any], newsKey: String) {
        self.newsKey = newsKey
        self.caption = value["caption"] as? String
        self.content = value["content"] as? String
        self.created_on = value["created_on"] as? CLong
        self.newspaper_id = value["newspaper_id"] as? String
        self.thumbnail = value["thumbnail"] as? String
    }
    
    
}
