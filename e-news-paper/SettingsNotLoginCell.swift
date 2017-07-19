//
//  SettingsNotLoginCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/15/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
//import Googl
import GoogleSignIn
import FBSDKLoginKit

class SettingsNotLoginCell: UITableViewCell , GIDSignInDelegate, GIDSignInUIDelegate{
    
    var dict : [String : AnyObject]!
    
    var settingsController: SettingsVC?
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: settingsController) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    @IBAction func googleLoginTapped(_ sender: Any) {
        // Initialize sign-in
        var configureError: NSError?
        //GGLContext.sharedInstance().configureWithError(&configureError)
        
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        if configureError != nil {
            //Handle your error
        }else {
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance().clientID = "850485727960-ls846mshpo90gno61cbtbq2f7ovp4qru.apps.googleusercontent.com"
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            
            
            GIDSignIn.sharedInstance().signIn()
        }
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    let msisdn = UserDefaults.standard.getMsisdn()
                    let email = self.dict["email"] as? String
                    let fname = self.dict["name"] as? String
                    guard let picsDict = self.dict["picture"] as? [String: Any] else {return}
                    guard let picd = picsDict["data"] as? [String: Any] else {return}
                    let picUrl = picd["url"] as? String
                    if let email = email, let fname = fname, let picUrl = picUrl{
                        
                        let usr = User(email: email, msisdn: msisdn, password: "", physical_address: "", profileImage: picUrl, username: fname, signinType: "Facebook")
                        
                        let value = [
                            
                            "email": email,
                            "msisdn": msisdn,
                            "password": "",
                            "physical_address": "",
                            "profileImage": picUrl,
                            "signinType": "Facebook",
                            "username": fname
                        ]
                        
                        self.pushUserToFirebase(value: value)
                        
                        UserDefaults.standard.saveUserDetails(user: usr)
                        UserDefaults.standard.setIsUserDetailsLoggedIn(value: true)
                        
                        self.settingsController?.tableView.reloadData()
                        print(UserDefaults.standard.isUserDetailsLoggedIn())
                    }
                    
                }
            })
        }
    }
    
    private func pushUserToFirebase(value: [String: Any]){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).child("users").setValue(value)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        facebookButton.setTitle(Localization("facebookText"), for: .normal)
        googleButton.setTitle(Localization("googleText"), for: .normal)
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            facebookButton.setTitle(Localization("facebookText"), for: .normal)
            googleButton.setTitle(Localization("googleText"), for: .normal)
        }
    }
    
    // MARK: - Memory management
    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotificationLanguageChanged, object: nil)
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
                let msisdn = UserDefaults.standard.getMsisdn()
                let usr = User(email: email, msisdn: msisdn, password: "", physical_address: "", profileImage: user.profile.imageURL(withDimension: 200).absoluteString, username: name, signinType: "Google")
                
                let value = [
                    
                    "email": email,
                    "msisdn": msisdn,
                    "password": "",
                    "physical_address": "",
                    "profileImage": user.profile.imageURL(withDimension: 200).absoluteString,
                    "signinType": "Facebook",
                    "username": name
                ]
                
                self.pushUserToFirebase(value: value)
                
                UserDefaults.standard.saveUserDetails(user: usr)
                UserDefaults.standard.setIsUserDetailsLoggedIn(value: true)
                self.settingsController?.tableView.reloadData()
            }
            
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Perform if user gets disconnected
    }
    
}
