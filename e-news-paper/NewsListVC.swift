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
    @IBOutlet weak var subscribeBtn: UIButton!
    
    @IBAction func subscribeButton(_ sender: Any) {
        handleReadMore()
    }
    
    
    fileprivate var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    fileprivate var storageRef = Storage.storage().reference()
    
    var vendor: NewsPaper?{
        didSet{
                let key = vendor?.vendorKey
                let userKey = UserDefaults.standard.getUserKey()
                
                AppFirRef.subscriberRef.child(userKey).child("susbscriptions").child(key!)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.key == key && !(snapshot.value  is NSNull){
                            print(snapshot)
                            self.isSubscribed = true
                            self.subscribeBtn.alpha = 0
                            self.readMoreButton.setTitle(Localization("readMoreText"), for: .normal)
                            
                        }
                        
                    })
        }
    }
    
    var newses = [News]()
    
    var filtered = [News]()
    
    var isSubscribed = false
    
    let readMoreButton: UIButton = {
       let button = UIButton()
        button.setTitle("Load More", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.75)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(readMoreButton)
        
        readMoreButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        readMoreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
        readMoreButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        readMoreButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        readMoreButton.addTarget(self, action: #selector(handleReadMore), for: .touchUpInside)
        
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
            if isSubscribed {
                return filtered.count
            }else{
                if filtered.count < 2{
                    return filtered.count
                }
                return 2
            }
            
        }
        if isSubscribed {
            return newses.count
        }else{
            if newses.count < 2{
                return filtered.count
            }
            return 2
        }
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

extension NewsListVC{
    
    func handleReadMore(){
        if(isSubscribed){
            isSubscribed = false
            self.subscribeBtn.alpha = 0
            unSubscribe(vendorId: (vendor?.vendorKey)!)
            
        }else{
            timelyConfig()
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
            self.readMoreButton.alpha = 0
            self.isSubscribed = true
        })
        let mobileAction = UIAlertAction(title: "Mobile Money", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.subscribe(vendorId: (self.vendor?.vendorKey)!)
            
            self.readMoreButton.alpha = 0
            
            self.isSubscribed = true
            
            self.tableView.isScrollEnabled = true
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
                
                let userKey = UserDefaults.standard.getUserKey()
                let subRef = Database.database().reference().child("newspapers").child((self.vendor?.vendorKey)!).child("users_subscribed")
                subRef.child(userKey).setValue(true)
                self.subscribeBtn.alpha = 0
                self.tableView.reloadData()
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

