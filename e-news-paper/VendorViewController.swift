//
//  VendorViewController.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase

class VendorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var searchBar: UISearchBar!
    
    var vendors = [NewsPaper]()
    
    var searchActive : Bool = false
    
    var filtered = [NewsPaper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        //searchBar.placeholder = "Find Contact"
        searchBar.delegate = self
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
        
        tableView.delegate = self
        tableView.dataSource = self
//
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        AppFirRef.newspaperRef.observe(.value, with: { (snapshot) in
            
            for case let snap as FIRDataSnapshot in snapshot.children{
                guard let value = snap.value as? [String : Any] else { return }
                
                print(value)
                let newspaper = NewsPaper(value: value, vendorKey: snap.key)
                self.vendors.append(newspaper)
                
            }
            

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func search(){
        self.navigationItem.titleView = self.searchBar;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(configureNavigationBar))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.searchActive = true
    }
    
    func configureNavigationBar(){
        searchActive = false
        tableView.reloadData()
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Vendors"
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showNewsList"{
            if let vendor = sender as? NewsPaper{
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationController?.navigationBar.barTintColor = .white
                navigationController?.navigationBar.tintColor = .black
                self.navigationItem.backBarButtonItem = backItem
                let newsListVc = segue.destination as! NewsListVC
                newsListVc.vendor = vendor
                newsListVc.hidesBottomBarWhenPushed = true
            }
        }
    }


}

extension VendorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
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
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorCell", for: indexPath) as! VendorCell
        
        let vendor: NewsPaper
        
        if(searchActive && searchBar.text != ""){
            vendor = filtered[indexPath.row]
            
        } else {
            vendor = vendors[indexPath.row]
        }
        
        cell.vendor = vendor
        
        cell.vendorViewController = self
        
        if let imageUrl = vendor.logo{
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                    if let updateCell = tableView.cellForRow(at: indexPath) as? VendorCell {
                        updateCell.vendorImageView.or_setImageWithURL(url: url! as NSURL
                        )
                    }
            
                
            })
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vendor = vendors[indexPath.item]
        
        self.performSegue(withIdentifier: "showNewsList", sender: vendor)
    }
    
}

extension VendorViewController: UISearchBarDelegate {
    
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
        
        filtered = vendors.filter { (vendor) -> Bool in
            let tmp: NSString = vendor.paper_name! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }
        self.tableView.reloadData()
    }
}
