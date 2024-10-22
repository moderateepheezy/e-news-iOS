//
//  AppFirRef.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Firebase

final class AppFirRef {

    static let baseRef = Database.database().reference()
    
    static var newsRef = baseRef.child("news")
    static var newspaperRef = baseRef.child("newspapers")
    static var subscriberRef = baseRef.child("subscriber")
    static var commentsRef = baseRef.child("comments")
    static var userRef = baseRef.child("subscriber").child("user_id").child("users")
}
