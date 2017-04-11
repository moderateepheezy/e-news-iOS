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
    
    var news: News?
    
    var vendor: NewsPaper?
    
    @IBOutlet weak var vendorNameLabel: UILabel!
    
    @IBOutlet weak var newsDateLabel: UILabel!

    @IBOutlet weak var vendorImageView: UIImageView!
    
    
    @IBOutlet weak var subscribedButton: UIButton!
    
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        subscribedButton.layer.cornerRadius = subscribedButton.frame.height / 2
        // Do any additional setup after loading the view.
        
        vendorNameLabel.text = vendor?.paper_name
        
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            return 400
        }
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
    
    func estimatedFrameForText(text: String, textSize: CGFloat) -> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: textSize)], context: nil)
    }
}
