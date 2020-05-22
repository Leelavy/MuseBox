//
//  CommentLocalDB.swift
//  MuseBox
//
//  Created by admin on 17/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit

extension Comment {
    
    static func createLocalDBTable(database: OpaquePointer?){
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS COMMENTS (COMMENT_ID TEXT PRIMARY KEY, POST_ID TEXT, USER_ID TEXT, USERNAME TEXT, PHOTO TEXT ,CONTENT TEXT)", nil, nil, &errorMessage);
        if(result != 0){
            print("error creating comments table")
            return
        }
        else {
            print("Success creating comments table!")
        }
    }
    
    func addToLocalDB(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"INSERT OR REPLACE INTO COMMENTS (COMMENT_ID, POST_ID, USER_ID, USERNAME, PHOTO, CONTENT) VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let commentId = self.commentId!.cString(using: .utf8)
            let postId = self.postId!.cString(using: .utf8)
            let userId = self.userId!.cString(using: .utf8)
            let username = self.username!.cString(using: .utf8)
            let profileImgUrl = self.profileImgUrl!.cString(using: .utf8)
            let content = self.content!.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, commentId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, postId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, userId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 4, username,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, profileImgUrl,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, content,-1,nil)

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to comments local DB!")
            }
            else {
                print("Could not add comment to loacl DB!")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllCommentsPerPost(postId:String)->[Comment]{
        
        var allCommentsPerPost = [Comment]()
        var sqlite3_stmt: OpaquePointer? = nil
        let query = "SELECT * from COMMENTS where POST_ID = '\(postId)'"
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let commentId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let postId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let userId = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let username = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let profileImgUrl = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let content = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                
                let recievedComment = Comment(commentId: commentId, postId: postId, userId: userId, username: username, profileImgUrl: profileImgUrl, content: content)
                allCommentsPerPost.append(recievedComment)
                print("Recieved comment from local DB!")
            }
        }
        else{
            print("Cant get all comments per post from local DB")
        }
        sqlite3_finalize(sqlite3_stmt)
        return allCommentsPerPost
    }
    
    static func getAllCommentsPerPostId(postId:String)->[String]{
        
        var allCommentsPerPostId = [String]()
        var sqlite3_stmt: OpaquePointer? = nil
        let query = "SELECT COMMENT_ID from COMMENTS where POST_ID = '\(postId)'"
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let commentId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                
                allCommentsPerPostId.append(commentId)
                print("Recieved comment Id from local DB!")
            }
        }
        else{
            print("Cant get comment Id from local DB")
        }
        sqlite3_finalize(sqlite3_stmt)
        return allCommentsPerPostId
    }
    
    static func deleteCommentFromLocalDB(commentId: String, callback: @escaping (Bool)-> Void) {
           
           var sqlite3_stmt: OpaquePointer? = nil
           let query = "DELETE from POSTS where COMMENT_ID = '\(commentId)'"
           if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
               
               if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                   print("Comment deleted from local DB.")
                   sqlite3_finalize(sqlite3_stmt)
                   callback(true)
               }
               else {
                   print("Could not delete comment from local DB.")
                   sqlite3_finalize(sqlite3_stmt)
                   callback(false)
               }
           }
       }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "COMMENTS", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "COMMENTS")
    }
}
