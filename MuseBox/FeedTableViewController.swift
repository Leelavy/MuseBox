//
//  FeedTableViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewController: UITableViewController, SignInViewControllerDelegate, FeedTableViewCellDelegate{
    
    var allCommentsIdToDelete = [String]()
    
    func feedTableViewCell(_ feedTableViewCell: FeedTableViewCell, deleteButtonTappedFor postId: String) {
        
        showIndicator(title: "deleting...", description: "")
        var title: String = "Post deleted"
        var message: String = ""
        Model.instance.deletePost(postId: postId) { (success) in
            if success {
                self.refreshControl?.beginRefreshing()
                self.allCommentsIdToDelete = Comment.getAllCommentsPerPostId(postId: postId)
                for commentId in self.allCommentsIdToDelete {
                    Model.instance.deleteComment(commentId: commentId) { (success) in
                        if success {
                            self.reloadData()
                        }
                    }
                }
                self.reloadData()
            }
            else {
                title = "Couldn't delete post.."
                message = "please try again"
                print("Error deleting post")
            }
            self.hideIndicator()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    var allPosts = [Post]()
    var selectedPost: Post?
    
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    
    
    func onSignInSuccess() {
        signButtonAppear()
    }
    
    func onSignInCancel() {
        signButtonAppear()
    }
    
    @IBAction func signIn_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "ToSignInSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSignInSegue" {
            let signInScreen:SignInViewController = segue.destination as! SignInViewController
            signInScreen.delegate = self
        }
        if segue.identifier == "ToCommentsSegue" {
            let commentsScreen: CommentsTableViewController = segue.destination as! CommentsTableViewController
            commentsScreen.post = selectedPost
        }
    }
    
    @objc func signOut(sender: UIBarButtonItem){
        Model.instance.signOut { (success) in
            if success {
                self.performSegue(withIdentifier: "ToSignInSegue", sender: self)
            }
            else {return}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        ModelEvents.newPostEvent.observe {
            self.refreshControl?.beginRefreshing()
            self.reloadData()
        }
        
        ModelEvents.deletePostEvent.observe {
            self.refreshControl?.beginRefreshing()
            self.reloadData()
        }
        
        self.refreshControl?.beginRefreshing()
        reloadData()
    }
    
    @objc func reloadData(){
        Model.instance.getAllPosts { (recievedData:[Post]?) in
            if recievedData != nil {
                self.allPosts = recievedData!.reversed()
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        signButtonAppear()
        self.tabBarController?.tabBar.isHidden = false
        self.reloadData()
    }
    
    func signButtonAppear(){
        if Model.instance.signedIn == false {
            let newSignInButton = UIBarButtonItem(title: "Sign In", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.signIn_TouchUpInside(_:)))
            newSignInButton.tintColor = UIColor(red: 0, green: 214, blue: 214, alpha: 1)
            self.navigationItem.leftBarButtonItem = newSignInButton
        }
        else {
            let newSignOutButton = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.signOut(sender:)))
            newSignOutButton.tintColor = UIColor(red: 0, green: 214, blue: 214, alpha: 1)
            self.navigationItem.leftBarButtonItem = newSignOutButton
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        
        let post = allPosts[indexPath.row]
        
        cell.postId = post.postId
        cell.delegate = self
        
        cell.deleteBtn.isHidden = true
        if post.userId == Model.instance.theUser.userId {
            cell.deleteBtn.isHidden = false
        }
        
        cell.topicLabel.text = "Topic: " + post.topic!
        cell.interestLabel.text = "Interests: " + post.interest!
        cell.contentTextView.text = post.content
        cell.contactLabel.text = "Contact: " + post.contact!
        cell.usernameLabel.text = post.username
        
        cell.profileImg.image = UIImage(named:"imgPlaceholder")
        if post.userImgUrl != ""{
            cell.profileImg.kf.setImage(with: URL(string: post.userImgUrl!))
        }
        cell.profileImg.setRounded()
        
        cell.postImg.image = UIImage(named: "imgPlaceholder")
        if post.photoUrl != ""{
            cell.postImg.kf.setImage(with: URL(string: post.photoUrl!))
        }
        
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(500)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = allPosts[indexPath.row]
        performSegue(withIdentifier: "ToCommentsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
