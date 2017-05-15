//
//  Comment.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

public class Comment{
    
    var text: String?
    var username: String?
    var timeSent: Double?
    var userImage: String?
    
    
    init(value: [String: Any]) {
        self.text = value["text"] as? String ?? ""
        self.username = value["username"] as? String ?? ""
        self.timeSent = value["timeSent"] as? Double ?? 0
        self.userImage = value["userImage"] as? String ?? ""
    }
}
