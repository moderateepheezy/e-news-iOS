//
//  VendorSettingsVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class VendorSettingsVC: UIViewController {
    
    var isSubscribed = false
    
    @IBOutlet weak var extendButton: UIButton!
    
    
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    @IBAction func extendSubButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        
        if(isSubscribed){
            isSubscribed = false
            self.subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.backgroundColor = .black
            unSubscribe(vendorId: (vendor?.vendorKey)!)
        }else{
            timelyConfig()
        }
        
        
    }
    
    
    var vendor: NewsPaper?{
        didSet{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadButtonstate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadButtonstate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadButtonstate()
    }
    
    func timelyConfig(){
        
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let attributedString = NSAttributedString(string: "", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here
            NSForegroundColorAttributeName : UIColor.black
            ])
        
        optionMenu.setValue(attributedString, forKey: "attributedTitle")
        
        let dailyAction = UIAlertAction(title: "Daily", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subType()
        })
        let weeklyAction = UIAlertAction(title: "Weekly", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subType()
        })
        
        let monthlyAction = UIAlertAction(title: "Monthly", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subType()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        optionMenu.addAction(dailyAction)
        optionMenu.addAction(weeklyAction)
        optionMenu.addAction(monthlyAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func subType(){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let attributedString = NSAttributedString(string: "Choose Option", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here
            NSForegroundColorAttributeName : UIColor.black
            ])
        
        optionMenu.setValue(attributedString, forKey: "attributedTitle")
        
        let directAction = UIAlertAction(title: "Direct Billing", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subscribe(vendorId: (self.vendor?.vendorKey)!)
            self.subscribeButton.backgroundColor = .red
            self.isSubscribed = true
        })
        let mobileAction = UIAlertAction(title: "Mobile Money", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subscribe(vendorId: (self.vendor?.vendorKey)!)
            self.subscribeButton.backgroundColor = .red
            self.isSubscribed = true
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        
        
        optionMenu.addAction(directAction)
        optionMenu.addAction(mobileAction)
        optionMenu.addAction(cancelAction)
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func subscribe(vendorId: String){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).queryOrdered(byChild: "susbscriptions").queryEqual(toValue: vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount.hashValue > 0 {
                
            }else{
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).setValue(true)
            }
            
        })
    }
    
    private func unSubscribe(vendorId: String){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.key == vendorId{
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).removeValue()
            }
        })
    }
    
    func loadButtonstate(){
        let key = vendor?.vendorKey
        let userKey = UserDefaults.standard.getUserKey()
        
        AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(key!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.key == key && !(snapshot.value  is NSNull){
                    print(snapshot)
                    self.isSubscribed = true
                    self.subscribeButton.backgroundColor = .red
                }
                
            })
    }

}
