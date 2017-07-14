//
//  VendorCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase

class VendorCell: UITableViewCell {
    
    var isSubscribed = false
    
    var vendorViewController: VendorViewController?
    
    var vendor: NewsPaper? {
        didSet{
            
            let key = vendor?.vendorKey
            let userKey = UserDefaults.standard.getUserKey()
            
            AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(key!)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.key == key && !(snapshot.value  is NSNull){
                        print(snapshot)
                        self.isSubscribed = true
                        self.subscribedButton.backgroundColor = .red
                    }
                    
                })
            
            if let name = vendor?.paper_name{
                vendorNameLabel.text = name
            }
            
            latestNewsLabel.text = vendor?.firstNews
        }
    }
    @IBOutlet weak var vendorImageView: UIImageView!
    
    @IBOutlet weak var latestNewsLabel: UILabel!
    
    @IBOutlet weak var vendorNameLabel: UILabel!

    @IBAction func subscripedTapped(_ sender: Any) {
        if(isSubscribed){
            isSubscribed = false
            self.subscribedButton.setTitle("Subscribe", for: .normal)
            subscribedButton.backgroundColor = .black
            unSubscribe(vendorId: (vendor?.vendorKey)!)
        }else{
            timelyConfig()
        }
    }
    
    @IBOutlet weak var subscribedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        
        subscribedButton.layer.cornerRadius = subscribedButton.frame.height / 2
        subscribedButton.setTitle(Localization("subscribeText"), for: .normal)
        
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            subscribedButton.setTitle(Localization("subscribeText"), for: .normal)
        }
    }
    
    // MARK: - Memory management
    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotificationLanguageChanged, object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        latestNewsLabel.text = ""
        vendorNameLabel.text = ""
        subscribedButton.backgroundColor = .black
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isVendorIsSbscribedTo(){
        AppFirRef.subscriberRef.child("user_key")
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
        
        vendorViewController?.present(optionMenu, animated: true, completion: nil)
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
            self.subscribedButton.backgroundColor = .red
            self.isSubscribed = true
        })
        let mobileAction = UIAlertAction(title: "Mobile Money", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subscribe(vendorId: (self.vendor?.vendorKey)!)
            self.subscribedButton.backgroundColor = .red
            self.isSubscribed = true
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        
        
        optionMenu.addAction(directAction)
        optionMenu.addAction(mobileAction)
        optionMenu.addAction(cancelAction)
        
        vendorViewController?.present(optionMenu, animated: true, completion: nil)
        
    }
    
    private func subscribe(vendorId: String){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).queryOrdered(byChild: "susbscriptions").queryEqual(toValue: vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount.hashValue > 0 {
                
            }else{
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).setValue(true)
                
                let userKey = UserDefaults.standard.getUserKey()
                let subRef = Database.database().reference().child("newspapers").child((self.vendor?.vendorKey)!).child("users_subscribed")
                subRef.child(userKey).setValue(true)
            }
            
        })
    }
    
    private func unSubscribe(vendorId: String){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.key == vendorId{
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).removeValue()
                
                let userKey = UserDefaults.standard.getUserKey()
                let subRef = Database.database().reference().child("newspapers").child((self.vendor?.vendorKey)!).child("users_subscribed")
                subRef.child(userKey).removeValue()
            }
        })
    }
}
