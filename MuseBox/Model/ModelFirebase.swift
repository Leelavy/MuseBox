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
        callback(true)
    }
    
    
    
}
