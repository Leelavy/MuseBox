//
//  ModelFirebase.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ModelFirebase {
    
    init() {
    }
    
    func addUserToDB(user: User){
        
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(user.userId!).setData(user.toJson()){ error in
            if error != nil {
                print("Error writing user to DB: \(error!.localizedDescription)")
            }
            else {
                print("User was added to the DB.")
            }
        }
    }
    
    func updateUserProfilePicture(userId: String, url: String, callback: (Bool)->Void){
        
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).updateData(["profileImg" : url])
        callback(true)
    }
    
    func addPostToDB(post: Post, callback:@escaping (Bool)->Void){
        
        let dataBase = Firestore.firestore()
        dataBase.collection("posts").document(post.postId!).setData(post.toJson()){ error in
            if error != nil {
                print("Error writing post to DB: \(error!.localizedDescription)")
                callback(false)
            }
            else {
                print("post was added to the DB.")
                callback(true)
            }
        }
    }
    
    func getAllPosts(since: Int64, callback: @escaping ([Post]?)->Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("posts").order(by: "lastUpdate", descending: false).start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var allPosts = [Post]()
                for document in querySnapshot!.documents {
                    if let timeStamp = document.data()["lastUpdate"] as? Timestamp {
                        let timeStampDate = timeStamp.dateValue()
                        print("\(timeStampDate)")
                        let timeStampDouble = timeStampDate.timeIntervalSince1970
                        print("\(timeStampDouble)")
                    }
                    print(document.data())
                    allPosts.append(Post(json: document.data()))
                }
                callback(allPosts);
            }
        };
    }
    
    
    
}
