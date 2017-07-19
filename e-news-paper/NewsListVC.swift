//
//  NewsListVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class NewsListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    fileprivate var storageRef = Storage.storage().reference()
    
    var vendor: NewsPaper?
    
    var newses = [News]()
    
    var filtered = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        //searchBar.placeholder = "Find Contact"
        searchBar.delegate = self
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .done, target: self, action: #selector(settings))
        settingsButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ settingsButton, searchBarButton]
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //navigationItem.title = vendor?.paper_name
        AppFirRef.newsRef.queryOrdered(byChild: "newspaper_id").queryEqual(toValue: vendor?.vendorKey).observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else { return }
            
            let news = News(value: value, newsKey: snapshot.key)
            self.newses.append(news)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.contentMode = .scaleAspectFit
        if let path = vendor?.logo{
            if let url = URL(string: path) {
                self.storageRef = Storage.storage().reference(withPath: url.path)
                imageView.sd_setImage(with: self.storageRef, placeholderImage: #imageLiteral(resourceName: "default"))
                self.navigationItem.titleView = imageView
            }
        }
    }
    
    func search(){
        self.navigationItem.titleView = self.searchBar;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(configureNavigationBar))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.searchActive = true
    }
    
    func settings(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VendorSettingsVC") as! VendorSettingsVC
        
        vc.vendor = vendor
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureNavigationBar(){
        searchActive = false
        tableView.reloadData()
        self.navigationItem.titleView = nil
        self.navigationItem.title = vendor?.paper_name
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .done, target: self, action: #selector(settings))
        settingsButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ settingsButton, searchBarButton]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetails"{
            if let news = sender as? News{
                let newsVc = segue.destination as! NewsDetailVC
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationController?.navigationBar.barTintColor = .white
                navigationController?.navigationBar.tintColor = .black
                self.navigationItem.backBarButtonItem = backItem
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
        
        
        if let path = news.thumbnail{
            if let url = URL(string: path) {
                self.storageRef = Storage.storage().reference(withPath: url.path)
                cell.newsImageView.sd_setImage(with: self.storageRef, placeholderImage: #imageLiteral(resourceName: "default"))
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive && searchBar.text != "") {
            
            if filtered.count != 0 {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
            }else{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
            
            return filtered.count
        }
        return newses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let news: News
        
        if(searchActive && searchBar.text != ""){
            news = filtered[indexPath.row]
            
        } else {
            news = newses[indexPath.row]
        }
        self.performSegue(withIdentifier: "ShowDetails", sender: news)
    }
    
    func loopWithCompletion(urls: [URL], _ indexPaths: [IndexPath], closure: () -> ()) {
        var urlss = urls
        for index in indexPaths{
            let news = newses[index.row]
            
            if let imageUrl = news.thumbnail{
                _ = ImageCacheLoader()
                let vendorStorageRef = Storage.storage().reference().child(imageUrl)
                vendorStorageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        return
                    }
                    urlss.append(url!)
                })
                
            }
        }
        closure()
    }
}

extension NewsListVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filtered = newses.filter { (news) -> Bool in
//            let tmp: NSString = news.caption?.english as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        }
        self.tableView.reloadData()
    }
}

