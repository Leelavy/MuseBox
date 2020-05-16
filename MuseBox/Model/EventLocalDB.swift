//
//  EventLocalDB.swift
//  MuseBox
//
//  Created by admin on 16/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit

extension Event {
    
    static func createLocalDBTable(database: OpaquePointer?){
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS EVENTS (EVENT_ID TEXT PRIMARY KEY, USER_ID TEXT, EVENT_NAME TEXT, DATE TEXT, TIME TEXT, LOCATION TEXT, DESCRIPTION TEXT, PHOTO TEXT)", nil, nil, &errorMessage);
        if(result != 0){
            print("error creating table");
            return
        }
    }
    
    func addToLocalDB(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"INSERT OR REPLACE INTO EVENTS(EVENT_ID, USER_ID, EVENT_NAME, DATE, TIME, LOCATION, DESCRIPTION, PHOTO) VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let eventId = self.eventId!.cString(using: .utf8)
            let userId = self.userId!.cString(using: .utf8)
            let eventName = self.eventName!.cString(using: .utf8)
            let date = self.date!.cString(using: .utf8)
            let time = self.time!.cString(using: .utf8)
            let location = self.location!.cString(using: .utf8)
            let description = self.description!.cString(using: .utf8)
            let eventImgUrl = self.eventImgUrl!.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, eventId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, userId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, eventName,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 4, date,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, time,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, location,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 7, description,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 8, eventImgUrl,-1,nil)

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to events local DB!")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllEventsFromLocalDB()->[Event]{
        var sqlite3_stmt: OpaquePointer? = nil
        var allEvents = [Event]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.localDatabase,"SELECT * from EVENTS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let eventId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let userId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let eventName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let date = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let time = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let location = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let description = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                let eventImgUrl = String(cString:sqlite3_column_text(sqlite3_stmt,7)!)
                
                let recievedEvent = Event(eventId: eventId, userId: userId, eventName: eventName, date: date, time: time, location: location, description: description, eventImgUrl: eventImgUrl)
                allEvents.append(recievedEvent)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return allEvents
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "EVENTS", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "EVENTS")
    }
}
