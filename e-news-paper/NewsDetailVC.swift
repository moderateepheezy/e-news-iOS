//
//  NewsDetailVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase


class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isSubscribed = false
    
    var news: News?
    
    
    @IBOutlet weak var vendorNameLabel: UILabel!
    
    @IBOutlet weak var newsDateLabel: UILabel!

    @IBOutlet weak var vendorImageView: UIImageView!
    
    
    @IBOutlet weak var subscribedButton: UIButton!
    
    
    
    var vendor: NewsPaper?{
        didSet{
            let key = vendor?.vendorKey
            let userKey = UserDefaults.standard.getUserKey()
            
            AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(key!)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.key == key && !(snapshot.value  is NSNull){
                        print(snapshot)
                        self.isSubscribed = true
                        self.subscribedButton.backgroundColor = .red
                        self.subscribedButton.setTitle("UnSubscribe", for: .normal)
                    }
                    
                })
            
            
        }
    }
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        if(isSubscribed){
            isSubscribed = false
            self.subscribedButton.setTitle("Subscribe", for: .normal)
            subscribedButton.backgroundColor = .black
            unSubscribe(vendorId: (vendor?.vendorKey)!)
        }else{
            timelyConfig()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        subscribedButton.layer.cornerRadius = subscribedButton.frame.height / 2
        
        vendorNameLabel.text = vendor?.paper_name
        
        if let created = news?.created_on {
            
            let date = NSDate(timeIntervalSince1970: TimeInterval(created))
            print(date)
            
            
            newsDateLabel.text = timeAgoSinceDate(date as Date, numericDates: true)
        }
        
        
        if let imageUrl = vendor?.logo{
            let imageLoader = ImageCacheLoader()
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                imageLoader.obtainImageWithPath(imagePath: (url?.absoluteString)!) { (image) in
                    self.vendorImageView.image = image
                }
                
            })
            
        }
        
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

}

class NewsTitle: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class NewsImage: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class NewsDescription: UITableViewCell{
    
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBAction func showMoreTapped(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        showMoreButton.layer.borderColor = UIColor.black.cgColor
        showMoreButton.layer.borderWidth = 2
        showMoreButton.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension NewsDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitle", for: indexPath) as! NewsTitle
            cell.titleLabel.text = news?.caption
            return cell
        }else if indexPath.item == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImage", for: indexPath) as! NewsImage
            
            if let imageUrl = news?.thumbnail{
                let imageLoader = ImageCacheLoader()
                
                let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
                vendorStorageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        return
                    }
                    
                    imageLoader.obtainImageWithPath(imagePath: (url?.absoluteString)!) { (image) in
                        // Before assigning the image, check whether the current cell is visible for ensuring that it's right cell
                        if let updateCell = tableView.cellForRow(at: indexPath) as? NewsImage {
                            updateCell.newsImageView.image = image
                        }
                    }
                    
                })
                
            }
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDescription", for: indexPath) as! NewsDescription
            cell.newsDescription.text = news?.content
            cell.newsDescription.requiredHeight()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0{
            return 65
        }else if indexPath.item == 1{
            return 200
        }else{
            guard let desc = news?.content else { return 10.01 }
            return estimatedFrameForText(text: desc, textSize: 17) - 300
        }
    }

    func estimatedFrameForText(text: String, textSize: CGFloat) -> CGFloat{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: textSize)], context: nil).height
    }
    
    
}

extension UILabel{
    
    func requiredHeight(){
        let label: UILabel = self;
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
    }

}
