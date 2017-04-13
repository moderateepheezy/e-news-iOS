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
    
    var vendors = [NewsPaper]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vendorRef = FIRDatabase.database().reference(withPath: "newspapers")
        vendorRef.keepSynced(true)
        
        tableView.delegate = self
        tableView.dataSource = self

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showNewsList"{
            if let vendor = sender as? NewsPaper{
                let newsListVc = segue.destination as! NewsListVC
                newsListVc.vendor = vendor
                newsListVc.hidesBottomBarWhenPushed = true
            }
        }
    }

}

extension VendorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorCell", for: indexPath) as! VendorCell
        
        let vendor = vendors[indexPath.row]
        
        cell.vendor = vendor
        
        
        if let imageUrl = vendor.logo{
            let imageLoader = ImageCacheLoader()
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                imageLoader.obtainImageWithPath(imagePath: (url?.absoluteString)!) { (image) in
                    // Before assigning the image, check whether the current cell is visible for ensuring that it's right cell
                    if let updateCell = tableView.cellForRow(at: indexPath) as? VendorCell {
                        updateCell.vendorImageView.image = image
                    }
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
