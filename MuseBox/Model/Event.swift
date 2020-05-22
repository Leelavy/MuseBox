//
//  Event.swift
//  MuseBox
//
//  Created by admin on 16/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Event {
    
    var eventId: String?
    var userId: String?
    var eventName: String?
    var date: String?
    var time: String?
    var location: String?
    var description: String?
    var eventImgUrl: String?
    var lastUpdate: Int64?
    
    
    init(eventId: String, userId: String, eventName: String, date: String, time: String, location: String, description: String, eventImgUrl: String = ""){
        
        self.eventId = eventId
        self.userId = userId
        self.eventName = eventName
        self.date = date
        self.time = time
        self.location = location
        self.description = description
        self.eventImgUrl = eventImgUrl
        self.lastUpdate = 0
        
    }
    
    convenience init(json:[String:Any]){
        
        let eventId = json["eventId"] as! String
        let userId = json["userId"] as! String
        let eventName = json["eventName"] as! String
        let date = json["date"] as! String
        let time = json["time"] as! String
        let location = json["location"] as! String
        let description = json["description"] as! String
        let eventImgUrl = json["eventImgUrl"] as! String
      
        self.init(eventId: eventId, userId: userId, eventName: eventName, date: date, time: time, location: location, description: description, eventImgUrl: eventImgUrl)
        
        let timeStamp = json["lastUpdate"] as! Timestamp
        self.lastUpdate = timeStamp.seconds
        
    }
    
    func toJson() -> [String:Any] {
        
        var json = [String:Any]()
        json["eventId"] = self.eventId
        json["userId"] = self.userId
        json["eventName"] = self.eventName
        json["date"] = self.date
        json["time"] = self.time
        json["location"] = self.location
        json["description"] = self.description
        json["eventImgUrl"] = self.eventImgUrl
        json["lastUpdate"] = FieldValue.serverTimestamp()
        
        return json
    }
}
