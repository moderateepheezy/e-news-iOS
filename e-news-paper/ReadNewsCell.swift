//
//  ReadNewsCell.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase

class ReadNewsCell: UITableViewCell {

    @IBOutlet weak var readNewsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var profileController: ProfileViewController?
    var newses = [News]()
    
    var vendor: NewsPaper?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        
        readNewsLabel.text = Localization("readNewsText")
        tableView.dataSource = self
        tableView.delegate = self
        
        let userKey = UserDefaults.standard.getUserKey()
        
        AppFirRef.subscriberRef.child(userKey).child("read_news").observe(.value, with: { (snapshot) in
            for case let snap as DataSnapshot in snapshot.children{
                
                let value = snap.key

                AppFirRef.newsRef.child(value).observeSingleEvent(of: .value, with: { (snapshot) in
                    

                    guard let value = snapshot.value as? [String : Any] else { return }
                
                    let news = News(value: value, newsKey: snap.key)
                    self.newses.append(news)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
                
            }
            
            
        })
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            readNewsLabel.text = Localization("readNewsText")
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

}

extension ReadNewsCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readNews", for: indexPath) as! ReadCell
        let news = newses[indexPath.item]
        
        AppFirRef.newspaperRef.child(news.newspaper_id!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            let vendor = NewsPaper(value: value, vendorKey: snapshot.key)
            self.vendor = vendor
        })
        
        cell.news = news
        
        if let imageUrl = news.thumbnail{
            
            let vendorStorageRef = Storage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                if let updateCell = tableView.cellForRow(at: indexPath) as? ReadCell {
                    updateCell.newsImageView.or_setImageWithURL(url: url! as NSURL)
                }
                
            })
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let news = newses[indexPath.item]
        
        let newsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        let backItem = UIBarButtonItem()
        backItem.title = ""
        profileController?.navigationController?.navigationBar.barTintColor = .white
        profileController?.navigationController?.navigationBar.tintColor = .black
        profileController?.navigationItem.backBarButtonItem = backItem
        newsVc.news = news
        newsVc.vendor = vendor
        newsVc.hidesBottomBarWhenPushed = true
        profileController?.navigationController?.pushViewController(newsVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newses.count
    }
}
