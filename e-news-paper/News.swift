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

    var created_on: CLong?
    var newspaper_id: String?
    var thumbnail: String?
    var newsKey: String?
    
    var fav: String?
    
    var content = Content()
    var caption = Caption()
    
    init() {
        
    }
    
    init(value: [String:  Any], newsKey: String) {
        self.newsKey = newsKey
        
        let contentDictionary = value["content"] as? [String: Any]
        self.content.english = contentDictionary?["english"] as? String
        self.content.french = contentDictionary?["french"] as? String
        
        self.created_on = value["created_on"] as? CLong
        self.newspaper_id = value["newspaper_id"] as? String
        self.thumbnail = value["thumbnail"] as? String
        
        let captionDictionary = value["caption"] as? [String: Any]
        self.caption.english = captionDictionary?["english"] as? String
        self.caption.french = captionDictionary?["french"] as? String
    }
    
    
}

struct Content {
    
    var english: String?
    var french: String?
    
}

struct Caption {
    
    var english: String?
    var french: String?
    
}
