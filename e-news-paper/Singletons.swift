//
//  Singletons.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/11/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation

class ENewsApp {
    
    static let sharedInstance = ENewsApp()
    
    

}

extension UserDefaults{
    
    enum UserDefaultsKey: String {
        case isLoggedIn
        case IsUserDetailsLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKey.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: UserDefaultsKey.isLoggedIn.rawValue)
    }
    
    func setIsUserDetailsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKey.IsUserDetailsLoggedIn.rawValue)
        synchronize()
    }
    
    func isUserDetailsLoggedIn() -> Bool{
        return bool(forKey: UserDefaultsKey.IsUserDetailsLoggedIn.rawValue)
    }
    
    func setMsisdn(value: String){
        set(value, forKey: "msisdn")
        setIsLoggedIn(value: true)
    }
    
    func getMsisdn() -> String{
        return string(forKey: "msisdn") ?? ""
    }
    
    func setUserKey(value: String){
        set(value, forKey: "user_key")
        setIsLoggedIn(value: true)
    }
    
    func getUserKey() -> String{
        return string(forKey: "user_key") ?? ""
    }
    
    func saveUserDetails(user: User){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        set(encodedData, forKey: "user")
        synchronize()
    }
    
    func fetchUserDetails() -> User{
        let decoded = object(forKey: "user") as! Data
        let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
        return decodedUser
    }
}
