//
//  User.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import UIKit

public class User: NSObject, NSCoding{
    
    var email: String?
    var msisdn: String?
    var password: String?
    var physical_address: String?
    var profileImage: String?
    var username: String?
    var signinType: String?
    
    
    init(email: String, msisdn: String, password: String,
         physical_address: String, profileImage: String,
         username: String, signinType: String) {
        
        self.email = email
        self.msisdn = msisdn
        self.password = password
        self.physical_address = physical_address
        self.profileImage = profileImage
        self.username = username
        self.signinType = signinType
    }
    
    required public init(coder decoder: NSCoder) {
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.msisdn = decoder.decodeObject(forKey: "msisdn") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "password") as? String ?? ""
        self.physical_address = decoder.decodeObject(forKey: "physical_address") as? String ?? ""
        self.profileImage = decoder.decodeObject(forKey: "profileImage") as? String ?? ""
        self.username = decoder.decodeObject(forKey: "username") as? String ?? ""
        self.signinType = decoder.decodeObject(forKey: "signinType") as? String ?? ""
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.msisdn, forKey: "msisdn")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.physical_address, forKey: "physical_address")
        aCoder.encode(self.profileImage, forKey: "profileImage")
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.signinType, forKey: "signinType")
    }
    

}
