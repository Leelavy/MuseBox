//
//  Model.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Model {
    
    static let instance = Model()
    var modelFirebase: ModelFirebase = ModelFirebase()
    
    var signedIn: Bool = false
    
    // Authentication
    
    func signUp(username: String, email: String, password: String, callback:@escaping (String?)->Void){
     
        Auth.auth().createUser(withEmail: email, password: password) { (authData: AuthDataResult?, error: Error?) in
            
            if error != nil {
                callback(nil)
            }
            else {
                let userId: String? = authData!.user.uid
                if userId != nil {
                    let newUser = User(userId: userId!, username: username, email: email, profileImg: "")
                    self.modelFirebase.addUserToDB(user: newUser)
                    callback(userId)
                }
            }
        }
    }
    
    func isSignedIn() -> Bool{
        return signedIn
    }
    
    func signIn(email:String, password:String, callback:@escaping (Bool)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authData: AuthDataResult?, error: Error?) in
            
            if error != nil {
                callback(false)
            }
            else {
                self.signedIn = true
                callback(true)
            }
        }
    }
    
    func signOut(callback: @escaping (Bool)->Void){
        
        do {
            try Auth.auth().signOut()
            signedIn = false
            callback(true)
        } catch let logoutError {
            print(logoutError.localizedDescription)
            callback(false)
        }
    }
    
    func saveImageGeneral(image:UIImage, category:String?, userId: String?, callback:@escaping (String)->Void) {
        FirbaseStorage.saveImageGeneral(image: image, category: category, userId: userId, callback: callback)
    }
    
    func updateUserProfilePicture(userId: String, url: String, callback:@escaping (Bool)->Void){
        modelFirebase.updateUserProfilePicture(userId: userId, url: url, callback: callback)
        
    }
    
    
}
