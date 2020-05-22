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
        ModelEvents.profileUpdateEvent.post()
        callback(true)
    }
    
    func updateUserDetails(userId: String, newUsername: String, newEmail: String, newProfileImg: String, newInfo: String, callback:@escaping (Bool)-> Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).updateData(["username" : newUsername])
        dataBase.collection("users").document(userId).updateData(["email" : newEmail])
        dataBase.collection("users").document(userId).updateData(["profileImg" : newProfileImg])
        dataBase.collection("users").document(userId).updateData(["info" : newInfo])
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let err = error {
                print("Error with changing email: \(err)")
                callback(false)
            }
        })
        ModelEvents.profileUpdateEvent.post()
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
                ModelEvents.newPostEvent.post()
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
        }
    }
    
    func deletePost(postId: String, callback:@escaping (Bool)->Void){
          
          let dataBase = Firestore.firestore()
          dataBase.collection("posts").document(postId).delete(){ error in
              if error != nil {
                  print("Error deleting post: \(error!.localizedDescription)")
                  callback(false)
              }
              else {
                  print("Post '\(postId )' deleted.")
                  callback(true)
              }
          }
      }
    
    func getPostImgUrlById(postId: String, callback: @escaping (String?)->Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("posts").document(postId).getDocument(source: .cache) { (document, error) in
            if let document = document {
                let url = document.get("photoUrl") as? String
                callback(url)
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func addEventToDB(event: Event, callback:@escaping (Bool)->Void){
        
        let dataBase = Firestore.firestore()
        dataBase.collection("events").document(event.eventId!).setData(event.toJson()){ error in
            if error != nil {
                print("Error writing event to DB: \(error!.localizedDescription)")
                callback(false)
            }
            else {
                print("event was added to the DB.")
                ModelEvents.newEventEvent.post()
                callback(true)
            }
        }
    }
    
    func getAllEvents(since: Int64, callback: @escaping ([Event]?)->Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("events").order(by: "lastUpdate", descending: false).start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil)
            } else {
                var allEvents = [Event]()
                for document in querySnapshot!.documents {
                    if let timeStamp = document.data()["lastUpdate"] as? Timestamp {
                        let timeStampDate = timeStamp.dateValue()
                        print("\(timeStampDate)")
                        let timeStampDouble = timeStampDate.timeIntervalSince1970
                        print("\(timeStampDouble)")
                    }
                    print(document.data())
                    allEvents.append(Event(json: document.data()))
                }
                callback(allEvents)
            }
        }
    }
    
    func addCommentToDB(comment: Comment, callback:@escaping (Bool)->Void){
        
        let dataBase = Firestore.firestore()
        dataBase.collection("comments").document(comment.commentId!).setData(comment.toJson()){ error in
            if error != nil {
                print("Error writing comment to DB: \(error!.localizedDescription)")
                callback(false)
            }
            else {
                print("comment was added to the DB.")
                //i should add comment's model event notification (post event)
                callback(true)
            }
        }
    }
    
    func getAllCommentsPerPost(since: Int64, postId: String, callback: @escaping ([Comment]?)->Void){
        let dataBase = Firestore.firestore()
        dataBase.collection("comments").order(by: "lastUpdate", descending: false).start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var allComments = [Comment]()
                for document in querySnapshot!.documents {
                    if let timeStamp = document.data()["lastUpdate"] as? Timestamp {
                        let timeStampDate = timeStamp.dateValue()
                        print("\(timeStampDate)")
                        let timeStampDouble = timeStampDate.timeIntervalSince1970
                        print("\(timeStampDouble)")
                    }
                    if let id = document.data()["postId"] as? String {
                        if id == postId {
                            print(document.data())
                            allComments.append(Comment(json: document.data()))
                        }
                    }
                }
                callback(allComments)
            }
        }
    }
    
    func deleteComment(commentId: String, callback:@escaping (Bool)->Void){
           
           let dataBase = Firestore.firestore()
           dataBase.collection("comments").document(commentId).delete(){ error in
               if error != nil {
                   print("Error deleting comment: \(error!.localizedDescription)")
                   callback(false)
               }
               else {
                   print("Comment '\(commentId )' deleted.")
                   callback(true)
               }
           }
       }
    
    
}
