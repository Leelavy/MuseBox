//
//  FeedTableViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewController: UITableViewController, SignInViewControllerDelegate{
    
    var allPosts = [Post]()
    
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    
    
    func onSignInSuccess() {
        let newSignOutButton = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.signOut(sender:)))
        newSignOutButton.tintColor = UIColor(red: 0, green: 214, blue: 214, alpha: 1)
        self.navigationItem.leftBarButtonItem = newSignOutButton
    }
    
    func onSignInCancel() {
        if Model.instance.signedIn == false {
            let newSignInButton = UIBarButtonItem(title: "Sign In", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.signIn_TouchUpInside(_:)))
            newSignInButton.tintColor = UIColor(red: 0, green: 214, blue: 214, alpha: 1)
            self.navigationItem.leftBarButtonItem = newSignInButton
        }
    }
    
    @IBAction func signIn_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "ToSignInSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSignInSegue" {
            let signInScreen:SignInViewController = segue.destination as! SignInViewController
            signInScreen.delegate = self
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
        
//        ModelEvents.StudentDataEvent.observe {
//            self.refreshControl?.beginRefreshing()
//            self.reloadData();
//        }
        self.refreshControl?.beginRefreshing()
        reloadData();
    }
    
    @objc func reloadData(){
        Model.instance.getAllPosts { (recievedData:[Post]?) in
            if recievedData != nil {
                self.allPosts = recievedData!
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        cell.profileImg.image = UIImage(named:"imgPlaceholder")
        cell.profileImg.setRounded()
        cell.topicLabel.text = "Topic: " + post.topic!
        cell.interestLabel.text = "Interests: " + post.interest!
        cell.contentTextView.text = post.content
        cell.contactLabel.text = "Contact: " + post.contact!
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
    

}
