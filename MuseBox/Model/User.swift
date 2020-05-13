//
//  User.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var username: String?
    var email: String?
    var profileImg: String?
    var userId: String?
    
    init(userId: String, username: String, email: String, profileImg: String = ""){
        
        self.userId = userId
        self.username = username
        self.email = email
        self.profileImg = profileImg
    }
    
    func toJson() -> [String:Any] {
        
        var json = [String:Any]()
        json["userId"] = self.userId
        json["username"] = self.username
        json["email"] = self.email
        json["profileImg"] = self.profileImg
        return json;
    }
    
}
