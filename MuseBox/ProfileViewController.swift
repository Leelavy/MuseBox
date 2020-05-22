//
//  ProfileViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, SignInViewControllerDelegate,EditProfileViewControllerDelegate {
   
    
    var user: User = Model.instance.theUser
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    func onEditSuccess() {
        updateProfilePage()
    }
       
    func onSignInSuccess() {
        usernameLabel.text = Model.instance.theUser.username
        emailLabel.text = Model.instance.theUser.email
        infoTextView.text = Model.instance.theUser.info
        if Model.instance.theUser.profileImg != "" {
            profileImg.kf.setImage(with: URL(string: Model.instance.theUser.profileImg!))
        }
        else {
            profileImg.image = UIImage(named: "imgPlaceholder")
        }
        profileImg.setRounded()
    }
    
    func onSignInCancel() {
        if !Model.instance.isSignedIn() {
            self.dismiss(animated: true, completion: {
                self.parent?.tabBarController?.selectedIndex = 0
            })
        }
        else {
            updateProfilePage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
        else{
            updateProfilePage()
        }
    }
    
    
    func updateProfilePage(){
        if Model.instance.theUser.profileImg != "" {
            profileImg.kf.setImage(with: URL(string: Model.instance.theUser.profileImg!))
        }
        else {
            profileImg.image = UIImage(named: "imgPlaceholder")
        }
        usernameLabel.text = Model.instance.theUser.username
        emailLabel.text = Model.instance.theUser.email
        infoTextView.text = Model.instance.theUser.info
        
        profileImg.setRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
        else {
            updateProfilePage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToEditProfileSegue"){
            let editProfile:EditProfileViewController = segue.destination as! EditProfileViewController
            editProfile.user = user
            editProfile.delegate = self
        }
    }
    

}
