//
//  Model.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Model {
    
    static let instance = Model()
    var modelFirebase: ModelFirebase = ModelFirebase()
    var theUser: User = User()
    
    var signedIn: Bool = false
    
    // Authentication
    
    func signUp(username: String, email: String, password: String, callback:@escaping (String?)->Void){
     
        Auth.auth().createUser(withEmail: email, password: password) { (authData: AuthDataResult?, error: Error?) in
            
            if error != nil {
                callback(nil)
            }
            else {
                let userId: String? = authData!.user.uid
                if userId != nil {
                    let newUser = User(userId: userId!, username: username, email: email, profileImg: "", info: "No info")
                    self.modelFirebase.addUserToDB(user: newUser)
                    callback(userId)
                }
            }
        }
    }
    
    func isSignedIn() -> Bool{
        return signedIn
    }
    
    func signIn(email:String, password:String, callback:@escaping (Bool)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authData: AuthDataResult?, error: Error?) in
            
            if error != nil {
                callback(false)
            }
            else {
                self.theUser.email = Auth.auth().currentUser?.email
                self.theUser.userId = Auth.auth().currentUser?.uid
                self.getUserProfileImg(userId: self.theUser.userId!, callback: { (profileImgUrl) in
                    self.theUser.profileImg = profileImgUrl
                })
                self.getUserUsername(userId: self.theUser.userId!) { (username) in
                    self.theUser.username = username
                }
                self.getUserInfo(userId: self.theUser.userId!) { (info) in
                    self.theUser.info = info
                }
                self.signedIn = true
                print(self.theUser.profileImg!)
                print(self.theUser.username!)

                callback(true)
            }
        }
    }
    
    func getUserProfileImg(userId: String, callback:@escaping (String)->Void) {
        let dataBase = Firestore.firestore()
        dataBase.collection("users").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
                callback("")
            } else {
                for user in querySnapshot!.documents {
                    if userId == user.data()["userId"] as? String {
                        if let imgUrl = user.data()["profileImg"] as? String {
                            print(imgUrl)
                            callback(imgUrl)
                        }
                    }
                }
            }
        }
    }
    
    func getUserUsername(userId: String, callback:@escaping (String)-> Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("users").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
                callback("")
            } else {
                for user in querySnapshot!.documents {
                    if userId == user.data()["userId"] as? String {
                        if let username = user.data()["username"] as? String {
                            print(username)
                            callback(username)
                        }
                    }
                }
            }
        }
    }
    
    func getUserInfo(userId: String, callback:@escaping (String)-> Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("users").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
                callback("")
            } else {
                for user in querySnapshot!.documents {
                    if userId == user.data()["userId"] as? String {
                        if let info = user.data()["info"] as? String {
                            print(info)
                            callback(info)
                        }
                    }
                }
            }
        }
    }
    
    func getUpdatedUserDetails(userId: String){
        theUser.email = Auth.auth().currentUser?.email
        theUser.userId = Auth.auth().currentUser?.uid
        getUserProfileImg(userId: self.theUser.userId!, callback: { (profileImgUrl) in
            self.theUser.profileImg = profileImgUrl
        })
        getUserUsername(userId: self.theUser.userId!) { (username) in
            self.theUser.username = username
        }
        getUserInfo(userId: self.theUser.userId!) { (info) in
            self.theUser.info = info
        }
        signedIn = true
    }
    
    func signOut(callback: @escaping (Bool)->Void){
        
        do {
            try Auth.auth().signOut()
            signedIn = false
            callback(true)
        } catch let logoutError {
            print(logoutError.localizedDescription)
            callback(false)
        }
    }
    
    func saveImageGeneral(image:UIImage, category:String?, id: String?, callback:@escaping (String?)->Void) {
        FirbaseStorage.saveImageGeneral(image: image, category: category, id: id, callback: callback)
    }
    
    func updateUserProfilePicture(userId: String, url: String, callback:@escaping (Bool)->Void){
        modelFirebase.updateUserProfilePicture(userId: userId, url: url, callback: callback)
        
    }
    
    func savePost(newPost: Post, postImage: UIImage?, callback: @escaping (Bool)->Void){
        
        var imgPostUrl:String?
        
        if postImage != nil {
            saveImageGeneral(image: postImage!, category: "posts", id: newPost.postId) { (imgUrl) in
                if imgUrl == nil {
                    imgPostUrl = ""
                }
                else {
                    imgPostUrl = imgUrl
                }
                let postToAdd = Post(userId: newPost.userId!,username: newPost.username!,userImgUrl: newPost.userImgUrl!, topic: newPost.topic!, interest: newPost.interest!, contact: newPost.contact!, content: newPost.content!, postId: newPost.postId!, photoUrl: imgPostUrl!)
                self.modelFirebase.addPostToDB(post: postToAdd) { (success) in
                    if success {
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
            }
        }
    }
    
    func getAllPosts(callback:@escaping ([Post]?)->Void){
                
        //get the local last update date
        let lud = Post.getLastUpdateDate()
        
        //get the cloud updates
        modelFirebase.getAllPosts(since: lud) { (data) in
            //insert update to the local db
            var lud:Int64 = 0
            for post in data!{
                post.addToLocalDB()
                if post.lastUpdate! > lud {lud = post.lastUpdate!}
            }
            //updates the post's local last update date
            Post.setLastUpdate(lastUpdated: lud)
            // get the complete student list
            let finalPostData = Post.getAllPostsFromLocalDB()
            callback(finalPostData);
        }
    }
    
    func deletePost(postId: String, callback: @escaping (Bool)->Void){
        self.modelFirebase.deletePost(postId: postId) { (success) in
            if success {
                Post.deletePostFromLocalDB(postId: postId) { (success) in
                    if success {
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
            }
            else {
                callback(false)
            }
        }
    }
    
    func deletePostImg(imgUrl: String, callback: @escaping (Bool)->Void){
        FirbaseStorage.deletePostImage(imageUrl: imgUrl) { (success) in
            if success {
                print("Post photo deleted from storage!")
                callback(true)
            }
            else {
                print("Couldn't delete post photo")
                callback(false)
            }
        }
        
    }
    
    func getPostImgUrlByPostId(postId: String, callback: @escaping (String?)->Void) {

        modelFirebase.getPostImgUrlById(postId: postId) { (imgUrl) in
            if let url = imgUrl {
                print("Got img url to delete: \(url)")
                callback(url)
            }
            else {
                print("Couldn't get img url to delete")
                callback(nil)
            }
        }
    }
    
    func updateUserDetails(userId: String, newUsername: String, newEmail: String, newProfileImg: String, newInfo: String, callback:@escaping (Bool)-> Void){
        modelFirebase.updateUserDetails(userId: userId, newUsername: newUsername, newEmail: newEmail, newProfileImg: newProfileImg, newInfo: newInfo) { (success) in
            if success {
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func saveEvent(newEvent: Event, eventImage: UIImage?, callback: @escaping (Bool)->Void){
        
        var imgEventUrl:String?
        
        if eventImage != nil {
            saveImageGeneral(image: eventImage!, category: "events", id: newEvent.eventId!) { (imgUrl) in
                if imgUrl == nil {
                    imgEventUrl = ""
                }
                else {
                    imgEventUrl = imgUrl
                }
                let eventToAdd = Event(eventId: newEvent.eventId!, userId: newEvent.userId!, eventName: newEvent.eventName!, date: newEvent.date!, time: newEvent.time!, location: newEvent.location!, description: newEvent.description!, eventImgUrl: imgEventUrl!)
                self.modelFirebase.addEventToDB(event: eventToAdd) { (success) in
                    if success {
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
            }
        }
    }
    
    func getAllEvents(callback:@escaping ([Event]?)->Void){
                
        //get the local last update date
        let lud = Event.getLastUpdateDate()
        
        //get the cloud updates
        modelFirebase.getAllEvents(since: lud) { (data) in
            //insert update to the local db
            var lud:Int64 = 0
            for event in data!{
                event.addToLocalDB()
                if event.lastUpdate! > lud {lud = event.lastUpdate!}
            }
            //updates the post's local last update date
            Event.setLastUpdate(lastUpdated: lud)
            // get the complete student list
            let finalEventData = Event.getAllEventsFromLocalDB()
            callback(finalEventData);
        }
    }
    
    func saveComment(newComment: Comment, callback: @escaping (Bool)->Void){
        self.modelFirebase.addCommentToDB(comment: newComment) { (success) in
            if success {
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func getAllCommentsPerPost(postId: String, callback:@escaping ([Comment]?)->Void){
        
        let lud = Comment.getLastUpdateDate()
        
        modelFirebase.getAllCommentsPerPost(since: lud, postId: postId) { (data) in
            var lud:Int64 = 0
            for comment in data!{
                print("Comment about to enter local DB")
                comment.addToLocalDB()
                if comment.lastUpdate! > lud {lud = comment.lastUpdate!}
            }
            Comment.setLastUpdate(lastUpdated: lud)
            let finalCommentsData = Comment.getAllCommentsPerPost(postId: postId)
            callback(finalCommentsData)
        }
    }
    
    func deleteComment(commentId: String, callback: @escaping (Bool)->Void){
        self.modelFirebase.deleteComment(commentId: commentId) { (success) in
            if success {
                Comment.deleteCommentFromLocalDB(commentId: commentId) { (success) in
                    if success {
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
            }
            else {
                callback(false)
            }
        }
    }
    
    
    
}

class ModelEvents{
    static let newPostEvent = EventNotificationBase(eventName: "com.MuseBox.newPostEvent")
    static let deletePostEvent = EventNotificationBase(eventName: "com.MuseBox.deletePostEvent")
    static let newEventEvent = EventNotificationBase(eventName: "com.MuseBox.newEventEvent")
    static let newCommentEvent = EventNotificationBase(eventName: "com.MuseBox.newCommentEvent")
    static let profileUpdateEvent = EventNotificationBase(eventName: "com.MuseBox.profileUpdateEvent")
    
    private init(){}
}

class EventNotificationBase{
    let eventName:String
    
    init(eventName:String){
        self.eventName = eventName
    }
    
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName),object: nil, queue: nil) { (data) in
            callback()
        }
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(eventName),object: self,userInfo: nil)
    }
}
