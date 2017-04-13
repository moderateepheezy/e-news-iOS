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
            
            AppFirRef.newsRef.queryOrdered(byChild: "newspaper_id").queryEqual(toValue: vendor?.vendorKey).queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot) in
                for case let snap as FIRDataSnapshot in snapshot.children{
                    guard let value = snap.value as? [String : Any] else { return }
                    
                    let news = News(value: value, newsKey: snap.key)
                    self.latestNewsLabel.text = news.caption
                }
            })
        }
    }
    @IBOutlet weak var vendorImageView: UIImageView!
    
    @IBOutlet weak var latestNewsLabel: UILabel!
    
    @IBOutlet weak var vendorNameLabel: UILabel!

    @IBAction func subscripedTapped(_ sender: Any) {
        isSubscribed = !isSubscribed
        if(isSubscribed){
            subscribe(vendorId: (vendor?.vendorKey)!)
            subscribedButton.backgroundColor = .red
        }else{
            subscribedButton.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var subscribedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subscribedButton.layer.cornerRadius = subscribedButton.frame.height / 2
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        vendorImageView.image = #imageLiteral(resourceName: "denews")
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
    
    private func subscribe(vendorId: String){
        let userKey = UserDefaults.standard.getUserKey()
        AppFirRef.subscriberRef.child(userKey).queryOrdered(byChild: "susbscriptions").queryEqual(toValue: vendorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount.hashValue > 0 {
                
            }else{
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(vendorId).setValue(true)
            }
            
        })
    }

}
