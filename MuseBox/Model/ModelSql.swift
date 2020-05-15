//
//  ModelSql.swift
//  MuseBox
//
//  Created by admin on 14/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation

class ModelSql{
    static let instance = ModelSql()

    var localDatabase: OpaquePointer? = nil
    
    private init() {
        let localDBFileName = "databaseMusebox3.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(localDBFileName)
            if sqlite3_open(path.absoluteString, &localDatabase) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        createLastUpdateTable();
        Post.createLocalDBTable(database: localDatabase)
    }
    
    deinit {
        sqlite3_close_v2(localDatabase);
    }
    
    private func createLastUpdateTable(){
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(localDatabase, "CREATE TABLE IF NOT EXISTS LAST_UPADATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errorMessage);
        if(result != 0){
            print("error creating LAST UPDATED table");
            return
        }
    }

    func setLastUpdate(name:String, lastUpdated:Int64){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(localDatabase,"INSERT OR REPLACE INTO LAST_UPADATED_DATE(NAME, DATE) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){

            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdated);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to last updated DB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getLastUpdateDate(name:String)->Int64{
        var date:Int64 = 0;
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(localDatabase,"SELECT * from LAST_UPADATE_DATE where NAME like ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
