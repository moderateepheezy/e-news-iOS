//
//  NotLoginCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google

class NotLoginCell: UITableViewCell, GIDSignInDelegate, GIDSignInUIDelegate{

    
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func googleLoginTapped(_ sender: Any) {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        if configureError != nil {
            //Handle your error
        }else {
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance().clientID = "850485727960-avv0chq3l1nvatglp79c007rmbocbgmt.apps.googleusercontent.com"
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            
            
            GIDSignIn.sharedInstance().signIn()
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
     UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let email = user.profile.email
            
            if let name = fullName, let email = email {
                let usr = User(email: email, msisdn: "", password: "", physical_address: "", profileImage: user.profile.imageURL(withDimension: 200).absoluteString, username: name, signinType: "Google")
                
                UserDefaults.standard.saveUserDetails(user: usr)
                UserDefaults.standard.setIsUserDetailsLoggedIn(value: true)
            }
            

        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Perform if user gets disconnected
    }

}
