//
//  LibraryViewController.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase


class LibraryViewController: UIViewController {
    
    var set = [NewsPaper]()
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
    
    fileprivate var storageRef = Storage.storage().reference()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = Localization("libraryText")
        //self.automaticallyAdjustsScrollViewInsets = false
        
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let id = UserDefaults.standard.getUserKey()
        
        AppFirRef.subscriberRef.child(id).child("susbscriptions").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            AppFirRef.newspaperRef.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.value is NSNull {
                    AppFirRef.subscriberRef.child(id).child("susbscriptions").child(snapshot.key).removeValue()
                    return
                }
                
                    guard let value = snapshot.value as? [String : Any] else { return }
                    
                    print(value)
                let newspaper = NewsPaper(value: value, vendorKey: snapshot.key)
                    self.set.append(newspaper)
                    
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
            
        })
        
        
    }
    
    


}
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCell", for: indexPath) as! LibraryCell
        
        let s = set[indexPath.item]
        
        cell.set =  s
        
        if let path = s.logo{
            if let url = URL(string: path) {
                self.storageRef = Storage.storage().reference(withPath: url.path)
                cell.vendorImage.sd_setImage(with: self.storageRef, placeholderImage: #imageLiteral(resourceName: "default"))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return set.count
    }
}


extension LibraryViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vendor = set[indexPath.item]
        
        self.performSegue(withIdentifier: "showNews", sender: vendor)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showNews"{
            if let vendor = sender as? NewsPaper{
                let newsListVc = segue.destination as! NewsListVC
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationController?.navigationBar.barTintColor = .white
                navigationController?.navigationBar.tintColor = .black
                self.navigationItem.backBarButtonItem = backItem
                newsListVc.vendor = vendor
                newsListVc.hidesBottomBarWhenPushed = true
            }
        }
    }
}

