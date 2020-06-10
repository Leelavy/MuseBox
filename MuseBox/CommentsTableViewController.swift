//
//  CommentsTableViewController.swift
//  MuseBox
//
//  Created by admin on 21/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit
import Kingfisher

class CommentsTableViewController: UITableViewController, SignInViewControllerDelegate {
    func onSignInSuccess() {
    }
    
    func onSignInCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var post: Post?
    var allComments = [Comment]()
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
        
        ModelEvents.newCommentEvent.observe {
            self.refreshControl?.beginRefreshing()
            self.reloadData()
        }
        
        handleSendButton()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = CGFloat(70)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        self.refreshControl?.beginRefreshing()
        reloadData()
    }
    
    @objc func reloadData(){
        Model.instance.getAllCommentsPerPost(postId: post!.postId!) { (recievedData:[Comment]?) in
            if recievedData != nil {
                self.allComments = recievedData!.reversed()
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    func emptyCommentField(){
        commentTextField.text = ""
        sendBtn.isEnabled = false
        
    }
    func handleSendButton(){
        commentTextField.addTarget(self, action: #selector(CommentsTableViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldsUpdated(){
        if commentTextField.text!.isEmpty {
            sendBtn.isEnabled = false
            return
        }
        sendBtn.setTitleColor(UIColor(displayP3Red: 0, green: 214, blue: 214, alpha: 1), for: UIControl.State.normal)
        sendBtn.isEnabled = true
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        showIndicator(title: "Commenting...", description: "")
        let newCommentId = UUID().uuidString
        let newComment = Comment(commentId: newCommentId, postId: post!.postId!, userId: Model.instance.theUser.userId!, username: Model.instance.theUser.username!, profileImgUrl: Model.instance.theUser.profileImg!, content: commentTextField.text!)
        Model.instance.saveComment(newComment: newComment) { (success) in
            if success {
                print("Success sending comment")
                self.emptyCommentField()
                self.refreshControl?.beginRefreshing()
                self.reloadData()
                self.hideIndicator()
            }
            else {
                print("failure sending comment")
                return
            }
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allComments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = allComments[indexPath.row]
        
        cell.usernameLabel.text = comment.username
        cell.commentLabel.text = comment.content
        
        cell.profileImg.image = UIImage(named:"imgPlaceholder")
        if comment.profileImgUrl != ""{
            cell.profileImg.kf.setImage(with: URL(string: comment.profileImgUrl!))
        }
        cell.profileImg.setRounded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }


}
