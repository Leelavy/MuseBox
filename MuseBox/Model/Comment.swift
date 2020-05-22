//
//  Comment.swift
//  MuseBox
//
//  Created by admin on 17/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Comment {
    
    var commentId: String?
    var postId: String?
    var userId: String?
    var username: String?
    var profileImgUrl: String?
    var content: String?
    var lastUpdate: Int64?

    init(commentId: String, postId: String, userId: String, username: String, profileImgUrl: String, content: String){
        
        self.commentId = commentId
        self.postId = postId
        self.userId = userId
        self.username = username
        self.profileImgUrl = profileImgUrl
        self.content = content
        self.lastUpdate = 0

    }
    
    convenience init(json:[String:Any]){
        
        let commentId = json["commentId"] as! String
        let postId = json["postId"] as! String
        let userId = json["userId"] as! String
        let username = json["username"] as! String
        let profileImgUrl = json["profileImgUrl"] as! String
        let content = json["content"] as! String
        
        self.init(commentId: commentId, postId: postId, userId: userId, username: username, profileImgUrl: profileImgUrl, content: content)
        
        let timeStamp = json["lastUpdate"] as! Timestamp
        self.lastUpdate = timeStamp.seconds
    }
    
    func toJson() -> [String:Any] {
        
        var json = [String:Any]()
        json["commentId"] = self.commentId
        json["postId"] = self.postId
        json["userId"] = self.userId
        json["username"] = self.username
        json["profileImgUrl"] = self.profileImgUrl
        json["content"] = self.content
        json["lastUpdate"] = FieldValue.serverTimestamp()
    
        return json
    }
    
}
