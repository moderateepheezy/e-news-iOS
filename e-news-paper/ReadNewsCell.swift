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

    @IBOutlet weak var tableView: UITableView!
    
    var newses = [News]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let userKey = UserDefaults.standard.getUserKey()
        
        AppFirRef.subscriberRef.child(userKey).child("read_news").observe(.value, with: { (snapshot) in
            for case let snap as FIRDataSnapshot in snapshot.children{
                
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ReadNewsCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readNews", for: indexPath) as! ReadCell
        let news = newses[indexPath.item]
        cell.news = news
        
        if let imageUrl = news.thumbnail{
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                if let updateCell = tableView.cellForRow(at: indexPath) as? ReadCell {
                    updateCell.newsImageView.or_setImageWithURL(url: url! as NSURL
                    )
                }
                
                
            })
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newses.count
    }
}
