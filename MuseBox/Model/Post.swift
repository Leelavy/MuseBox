//
//  Post.swift
//  MuseBox
//
//  Created by admin on 14/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    var userId: String?
    var username: String?
    var userImgUrl: String?
    var postId: String?
    var topic: String?
    var interest: String?
    var contact: String?
    var content: String?
    var photoUrl: String?
    var lastUpdate: Int64?
    
    
    init(userId: String, username: String, userImgUrl: String, topic: String, interest: String, contact: String, content: String, postId: String, photoUrl: String = ""){
        
        self.userId = userId
        self.username = username
        self.userImgUrl = userImgUrl
        self.topic = topic
        self.interest = interest
        self.contact = contact
        self.content = content
        self.postId = postId
        self.photoUrl = photoUrl
        self.lastUpdate = 0
        
    }
    
    convenience init(json:[String:Any]){
        
        let userId = json["userId"] as! String
        let username = json["username"] as! String
        let userImgUrl = json["userImgUrl"] as! String
        let postId = json["postId"] as! String
        let topic = json["topic"] as! String
        let interest = json["interest"] as! String
        let contact = json["contact"] as! String
        let content = json["content"] as! String
        let photoUrl = json["photoUrl"] as! String
        
        self.init(userId: userId, username: username, userImgUrl: userImgUrl, topic: topic, interest: interest , contact: contact, content: content, postId: postId, photoUrl: photoUrl)
        
        let ts = json["lastUpdate"] as! Timestamp
        self.lastUpdate = ts.seconds

    }
    
    func toJson() -> [String:Any] {
        
        var json = [String:Any]()
        json["userId"] = self.userId
        json["username"] = self.username
        json["userImgUrl"] = self.userImgUrl
        json["postId"] = self.postId
        json["topic"] = self.topic
        json["interest"] = self.interest
        json["contact"] = self.contact
        json["content"] = self.content
        json["photoUrl"] = self.photoUrl
        json["lastUpdate"] = FieldValue.serverTimestamp()
        
        return json
    }
    
}
