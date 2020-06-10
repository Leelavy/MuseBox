//
//  SignUpViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImg: UIImage?
    var user: User?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var errorSignUpMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.isHidden = true
        
        profileImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        profileImg.addGestureRecognizer(tap)
        handleSignUpButton()
        
    }
    
    func handleSignUpButton(){
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldsUpdated(){
        if usernameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signUpBtn.isEnabled = false
            return
        }
        signUpBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpBtn.isEnabled = true
        
    }
    
    @objc func handleTap() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImg = image
            self.profileImg.image = image
            self.profileImg.setRounded() //extension
        }
        dismiss(animated: true, completion: nil)

    }

    
    @IBAction func backToSignIn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SignUpBtn_TouchUpInside(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" || emailTextField.text == "" {
            self.errorSignUpMsg.text = "Please fill all fields"
            return
        }
        self.loader.isHidden = false
        Model.instance.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { (userId) in
            if userId != nil {
                if let selectedImg = self.selectedImg {
                    Model.instance.saveImageGeneral(image: selectedImg, category: "profile_image", id: userId) { (imgUrl) in
                        Model.instance.updateUserProfilePicture(userId: userId!, url: imgUrl!) { (success) in
                            if success {
                                print("profile picture updated")
                            }
                        }
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.loader.isHidden = true
                self.errorSignUpMsg.text = "Error with signup. please try again"
            }
        }
    }
    
}
