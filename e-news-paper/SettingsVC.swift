//
//  SettingsVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/15/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var isUserLogin = UserDefaults.standard.isUserDetailsLoggedIn()
    
    var user: User?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUser()
    }
    
    
    
    func getUser() {
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull{
                
            }else{
                let userd = User(value: snapshot.value as! [String : Any])
                UserDefaults.standard.saveUserDetails(user: userd)
                
                let user = UserDefaults.standard.fetchUserDetails()
                self.user = user
                self.tableView.reloadData()
            }
        })
    }

}


extension SettingsVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0{
            
            print(UserDefaults.standard.isUserDetailsLoggedIn())
            if isUserLogin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLoggedInCell", for: indexPath) as! SettingsLoggedInCell
                
                let user = UserDefaults.standard.fetchUserDetails()
                
                cell.usernameLabel.text = user.username
                cell.userEmailLabel.text = user.email
                cell.userPhoneNumberLabel.text = user.msisdn
                
                
                return cell
                
            }else if let user = self.user,
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLoggedInCell", for: indexPath) as? SettingsLoggedInCell {
                
                
                cell.usernameLabel.text = user.username
                cell.userEmailLabel.text = user.email
                cell.userPhoneNumberLabel.text = user.msisdn
                
                return cell
                
            }else if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsNotLoginCell", for: indexPath) as? SettingsNotLoginCell {
                
                cell.settingsController = self
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingsCell", for: indexPath) as! GeneralSettingsCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0{
            return 134
        }else{
            return 235
        }
    }
}
