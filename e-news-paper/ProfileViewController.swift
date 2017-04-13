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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
    }


}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0{
            if isUserLogin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loggedIn", for: indexPath) as! LoggedInCell
                
                return cell
            
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "notLoggedIN", for: indexPath) as! NotLoginCell
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readNewsCell", for: indexPath) as! ReadNewsCell
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

