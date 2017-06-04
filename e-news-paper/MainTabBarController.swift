//
//  MainViewController.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import NDParallaxIntroView

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isLoggedin()){
            setupTab()
        }else{
            perform(#selector(showLoginController), with: nil,afterDelay: 0.01)
        }
        
    }
    
    fileprivate func isLoggedin() -> Bool {
        print("isLoggedin\(UserDefaults.standard.isLoggedIn())")
        return UserDefaults.standard.isLoggedIn()
    }
    
    func showLoginController(){
        let vc = IntroVC()
        present(vc, animated: true, completion: nil)

    }
    
    private func setupTab(){
        let unselectedColor = UIColor(red: 98, green: 95, blue: 95)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor, NSFontAttributeName: UIFont.systemFont(ofSize: 14)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 14)], for: .selected)
        
        
        let vendor = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VendorViewController")
        let vendorVC = UINavigationController(rootViewController: vendor)
        vendorVC.tabBarItem = UITabBarItem(title: "VENDOR", image: #imageLiteral(resourceName: "add_list"), tag: 0)
        
        let library = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LibraryViewController")
        let libraryVC = UINavigationController(rootViewController: library)
        libraryVC.tabBarItem = UITabBarItem(title: "LIBRARY", image: #imageLiteral(resourceName: "stack"), tag: 0)
        
        let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")
        let profileVC = UINavigationController(rootViewController: profile)
        profileVC.tabBarItem = UITabBarItem(title: "PROFILE", image: #imageLiteral(resourceName: "user"), tag: 0)
        
        self.viewControllers = [vendorVC, libraryVC, profileVC]
        self.selectedIndex = 0
        
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
    }
    
    
}

