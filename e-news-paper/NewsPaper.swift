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
    var display: Bool?
    var method: String?
    var status: String?
    var news: [String: Any]?
    var firstNews: String?
    
    init(value: [String: Any], vendorKey: String) {
        self.vendorKey = vendorKey
        self.logo = value["logo"] as? String
        self.paper_name = value["paper_name"] as? String
        self.display = value["display"] as? Bool
        self.method = value["method"] as? String
        self.status = value["status"] as? String
        self.news = value["news"] as? [String: Any]
        let firs = self.news?.first?.value as? NSDictionary
        let caption = firs?.value(forKey: "caption") as? NSDictionary
        
        if Localization("English_en") == "Anglais" {
            if caption?.value(forKey: "french") as? String != "" {
                self.firstNews = caption?.value(forKey: "french") as? String
            }else{
                self.firstNews = caption?.value(forKey: "english") as? String
            }
        }else{
            if caption?.value(forKey: "english") as? String != "" {
                self.firstNews = caption?.value(forKey: "english") as? String
            }else{
                self.firstNews = caption?.value(forKey: "french") as? String
            }
        }
    }
}

