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
    
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //self.automaticallyAdjustsScrollViewInsets = false
        
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let id = UserDefaults.standard.getUserKey()
        
        AppFirRef.subscriberRef.child(id).child("susbscriptions").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            AppFirRef.newspaperRef.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
        
        if let imageUrl = s.logo{
            let imageLoader = ImageCacheLoader()
            
            let vendorStorageRef = FIRStorage.storage().reference().child(imageUrl)
            vendorStorageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                
                imageLoader.obtainImageWithPath(imagePath: (url?.absoluteString)!) { (image) in
                    // Before assigning the image, check whether the current cell is visible for ensuring that it's right cell
                    
                    if let updateCell = collectionView.cellForItem(at: indexPath) as? LibraryCell {
                        updateCell.vendorImage.image = image
                    }
                }
                
            })
            
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
                newsListVc.vendor = vendor
                newsListVc.hidesBottomBarWhenPushed = true
            }
        }
    }
}