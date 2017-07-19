

//
//  ViewController.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isUserLogin = UserDefaults.standard.isUserDetailsLoggedIn()
    
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = Localization("profileText")
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let settingBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(goSettings))
        settingBarButton.tintColor = UIColor.black
        
        getUser()
        
        
        self.navigationItem.rightBarButtonItems = [ settingBarButton]
        
    }
    
    
    @objc private func goSettings(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        navigationController?.pushViewController(vc, animated: true)
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0{
            
            print(UserDefaults.standard.isUserDetailsLoggedIn())
            if isUserLogin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loggedIn", for: indexPath) as! LoggedInCell
                
                let user = UserDefaults.standard.fetchUserDetails()
                
                cell.usernameLabel.text = user?.username
                cell.userEmailLabel.text = user?.email
                cell.userPhoneNumberLabel.text = user?.msisdn
                
                
                
                if let imgUrl = user?.profileImage {
                    let url = URL(fileURLWithPath: imgUrl)
                    
                    cell.userProfileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "pp"))
                }
                
                return cell
            
            }else if let user = self.user,
                let cell = tableView.dequeueReusableCell(withIdentifier: "loggedIn", for: indexPath) as? LoggedInCell {
                
                let url = URL(fileURLWithPath: user.profileImage)
                
                cell.usernameLabel.text = user.username
                cell.userEmailLabel.text = user.email
                cell.userPhoneNumberLabel.text = user.msisdn
                cell.userProfileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "pp"))
                
                return cell
                
            }else if let cell = tableView.dequeueReusableCell(withIdentifier: "notLoggedIN", for: indexPath) as? NotLoginCell {
                
                cell.profileController = self
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readNewsCell", for: indexPath) as! ReadNewsCell
        cell.profileController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0{
            return 200
        }else{
            return 400
        }
    }
}

