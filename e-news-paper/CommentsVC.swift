//
//  CommentsVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 5/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {
    
    var news: News?
    
    var comments = [Comment]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!

    @IBAction func sendCommentTapped(_ sender: Any) {
        
        guard let text = commentTextField.text else { return }
        if text.isEmpty{
            
        }else{
            let user = UserDefaults.standard.fetchUserDetails()
            
            let uname = user.username ?? "Anonymous"
            let userImage = user.profileImage ?? ""
            let timeSent = NSDate().timeIntervalSince1970
            print(timeSent)
            let value = [
                
                "text": text,
                "username": uname,
                "timeSent": timeSent,
                "userImage": userImage
                
            ] as [String : Any]
            
            pushComment(value: value)
            
            commentTextField.text = ""
        }
    }
    
    private func pushComment(value: [String: Any]){
        
        guard let key = news?.newsKey else {return}
        AppFirRef.commentsRef.child(key).childByAutoId().setValue(value)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        guard let key = news?.newsKey else {return}
        
        AppFirRef.commentsRef.child(key).observe(.childAdded, with: { (snapshot) in
            
            //for case let snap as FIRDataSnapshot in snapshot.children{
                guard let value = snapshot.value as? [String : Any] else { return }
            let comment = Comment(value: value)
            self.comments.append(comment)
            self.tableView.reloadData()
                
           // }
        })
    }

}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
        
    }
}
