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
                    let newUser = User(userId: userId!, username: username, email: email, profileImg: "")
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
                self.signedIn = true
                callback(true)
            }
        }
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
                let postToAdd = Post(topic: newPost.topic!, interest: newPost.interest!, contact: newPost.contact!, content: newPost.content!, postId: newPost.postId!, photoUrl: imgPostUrl!)
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
    
    
    
    
}
