//
//  NewsListVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase

class NewsListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var vendor: NewsPaper?
    
    var newses = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsRef = FIRDatabase.database().reference(withPath: "news")
        newsRef.keepSynced(true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = vendor?.paper_name
        
        AppFirRef.newsRef.queryOrdered(byChild: "newspaper_id").queryEqual(toValue: vendor?.vendorKey).observe(.value, with: { (snapshot) in
            for case let snap as FIRDataSnapshot in snapshot.children{
                guard let value = snap.value as? [String : Any] else { return }
                
                let news = News(value: value, newsKey: snap.key)
                self.newses.append(news)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetails"{
            if let news = sender as? News{
                let newsVc = segue.destination as! NewsDetailVC
                newsVc.news = news
                newsVc.vendor = vendor
                newsVc.hidesBottomBarWhenPushed = true
            }
        }else if segue.identifier == "ShowSettings"{
            if let vendor = sender as? NewsPaper{
                let settingsVc = segue.destination as! VendorSettingsVC
                settingsVc.vendor = vendor
            }
        }
    }
    
    
    @IBAction func settingsTapped(_ sender: Any) {
    
        self.performSegue(withIdentifier: "ShowSettings", sender: vendor)
    }


}

extension NewsListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell", for: indexPath) as! NewsListCell
        
        let news = newses[indexPath.row]
        
        cell.vendorNameLabel.text = vendor?.paper_name
        
        cell.news = news
        
        if let imageUrl = news.caption{
            let imageLoader = ImageCacheLoader()
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                imageLoader.obtainImageWithPath(imagePath: (url?.absoluteString)!) { (image) in
                    // Before assigning the image, check whether the current cell is visible for ensuring that it's right cell
                    if let updateCell = tableView.cellForRow(at: indexPath) as? NewsListCell {
                        updateCell.newsImageView.image = image
                    }
                }
                
            })
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newses[indexPath.item]
        self.performSegue(withIdentifier: "ShowDetails", sender: news)
    }
}
