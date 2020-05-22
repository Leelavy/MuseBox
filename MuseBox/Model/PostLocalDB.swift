//
//  PostLocalDB.swift
//  MuseBox
//
//  Created by admin on 14/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit

extension Post{
    
    static func createLocalDBTable(database: OpaquePointer?){
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (POST_ID TEXT PRIMARY KEY, USER_ID TEXT, USERNAME TEXT, USERIMG TEXT, TOPIC TEXT, INTEREST TEXT, CONTACT TEXT, CONTENT TEXT, PHOTO TEXT)", nil, nil, &errorMessage);
        if(result != 0){
            print("error creating posts table");
            return
        }
    }
    
    func addToLocalDB(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"INSERT OR REPLACE INTO POSTS(POST_ID, USER_ID, USERNAME, USERIMG, TOPIC, INTEREST, CONTACT, CONTENT, PHOTO) VALUES (?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let postId = self.postId!.cString(using: .utf8)
            let userId = self.userId!.cString(using: .utf8)
            let username = self.username!.cString(using: .utf8)
            let userImgUrl = self.userImgUrl!.cString(using: .utf8)
            let topic = self.topic!.cString(using: .utf8)
            let interest = self.interest!.cString(using: .utf8)
            let contact = self.contact!.cString(using: .utf8)
            let content = self.content!.cString(using: .utf8)
            let photoUrl = self.photoUrl!.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, userId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, username,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 4, userImgUrl,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, topic,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, interest,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 7, contact,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 8, content,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 9, photoUrl,-1,nil)
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to local DB!")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllPostsFromLocalDB()->[Post]{
        var sqlite3_stmt: OpaquePointer? = nil
        var allPosts = [Post]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"SELECT * from POSTS;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let postId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let userId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let username = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let userImgUrl = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let topic = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let interest = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let contact = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                let content = String(cString:sqlite3_column_text(sqlite3_stmt,7)!)
                let photoUrl = String(cString:sqlite3_column_text(sqlite3_stmt,8)!)
                let recievedPost = Post(userId: userId, username: username, userImgUrl: userImgUrl, topic: topic, interest: interest, contact: contact, content: content, postId: postId, photoUrl: photoUrl)
                allPosts.append(recievedPost)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return allPosts
    }
    
    static func deletePostFromLocalDB(postId: String, callback: @escaping (Bool)-> Void) {
        
        var sqlite3_stmt: OpaquePointer? = nil
        let query = "DELETE from POSTS where POST_ID = '\(postId)'"
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("Post deleted from local DB.")
                sqlite3_finalize(sqlite3_stmt)
                callback(true)
            }
            else {
                print("Could not delete post from local DB.")
                sqlite3_finalize(sqlite3_stmt)
                callback(false)
            }
        }
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "POSTS", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "POSTS")
    }
}
