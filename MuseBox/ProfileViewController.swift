//
//  ProfileViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, SignInViewControllerDelegate {
    
    func onSignInSuccess() {
    }
    
    func onSignInCancel() {
        self.dismiss(animated: true, completion: {
            self.parent?.tabBarController?.selectedIndex = 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
