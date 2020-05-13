//
//  FirebaseStorage.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirbaseStorage {
    
//    static func saveImage(image:UIImage, callback:@escaping (String)->Void){
//        let refStorage = Storage.storage().reference(forURL:
//            "gs://musebox-app.appspot.com")
//        let data = image.jpegData(compressionQuality: 0.5)
//        let refImg = refStorage.child("imageName")
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        refImg.putData(data!, metadata: metadata) { (metadata, error) in
//            refImg.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    return
//                }
//                print("url: \(downloadURL)")
//                callback(downloadURL.absoluteString)
//            }
//        }
//    }
    
    static func saveImageGeneral(image:UIImage, category:String?, userId: String?, callback:@escaping (String)->Void){
        
        let refStorage = Storage.storage().reference(forURL:"gs://musebox-app.appspot.com")
        let data = image.jpegData(compressionQuality: 0.1)
        var refImg = Storage.storage().reference()
           
        if category == nil {
            refImg = refStorage.child("general")
        }
        else if (category == "profile_image" && userId != nil){
            refImg = refStorage.child(category!).child(userId!)
        }
        else {
            refImg = refStorage.child(category!)
         }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        refImg.putData(data!, metadata: metadata) { (metadata, error) in
            refImg.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
       
    
}
