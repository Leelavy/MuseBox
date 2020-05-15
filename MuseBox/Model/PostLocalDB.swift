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
        let result = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (POST_ID TEXT PRIMARY KEY, TOPIC TEXT, INTEREST TEXT, CONTACT TEXT, CONTENT TEXT, PHOTO TEXT)", nil, nil, &errorMessage);
        if(result != 0){
            print("error creating table");
            return
        }
    }
    
    func addToLocalDB(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"INSERT OR REPLACE INTO POSTS(POST_ID, TOPIC, INTEREST, CONTACT, CONTENT, PHOTO) VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let postId = self.postId!.cString(using: .utf8)
            let topic = self.topic!.cString(using: .utf8)
            let interest = self.interest!.cString(using: .utf8)
            let contact = self.contact!.cString(using: .utf8)
            let content = self.content!.cString(using: .utf8)
            let photoUrl = self.photoUrl!.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, topic,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, interest,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 4, contact,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, content,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, photoUrl,-1,nil)
            
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
                let topic = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let interest = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let contact = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let content = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let photoUrl = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let recievedPost = Post(topic: topic, interest: interest, contact: contact, content: content, postId: postId, photoUrl: photoUrl)
                allPosts.append(recievedPost)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return allPosts
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "POSTS", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "POSTS")
    }
}
