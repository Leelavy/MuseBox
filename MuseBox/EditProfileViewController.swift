//
//  EditProfileViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerDelegate{
    func onEditSuccess()
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate:EditProfileViewControllerDelegate?
    var user: User = Model.instance.theUser
    var selectedImg: UIImage?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Model.instance.isSignedIn() {
            updateEditProfilePage()
        }
        
        profileImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        profileImg.addGestureRecognizer(tap)
           
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Model.instance.isSignedIn() {
            updateEditProfilePage()
        }
        
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
    
    func updateEditProfilePage(){
        usernameTextField.placeholder = user.username
        emailTextField.placeholder = user.email
        if user.profileImg != "" {
            profileImg.kf.setImage(with: URL(string: (user.profileImg!)))
        }
        else {
            profileImg.image = UIImage(named: "imgPlaceholder")
        }
        profileImg.setRounded()
        infoTextView.text = user.info
    }
    
    @IBAction func saveChanges_TouchUpInside(_ sender: Any) {
        var newUsername = user.username
        var newEmail = user.email
        var newInfo = user.info
        
        showIndicator(title: "Updating...", description: "")
        if usernameTextField.text == "" {
            newUsername = usernameTextField.placeholder!
        }
        else {
            newUsername = usernameTextField.text!
            Model.instance.theUser.username = newUsername

        }
        if emailTextField.text == "" {
            newEmail = emailTextField.placeholder!
        }
        else {
            newEmail = emailTextField.text!
            Model.instance.theUser.email = newEmail
        }
        if infoTextView.text != user.info {
            newInfo = infoTextView.text
            Model.instance.theUser.info = newInfo
        }
        if selectedImg != nil {
            //delete current img in storage
            Model.instance.saveImageGeneral(image: selectedImg!, category: "profile_image", id: user.userId) { (imgUrl) in
                if imgUrl != nil {
                    Model.instance.theUser.profileImg = imgUrl
                    Model.instance.updateUserProfilePicture(userId: self.user.userId!, url: imgUrl!) { (success) in
                        if success {
                            Model.instance.updateUserDetails(userId: self.user.userId!, newUsername: newUsername!, newEmail: newEmail!, newProfileImg: imgUrl!, newInfo: newInfo!) { (success) in
                                if success {
                                    if let delegate = self.delegate{
                                        delegate.onEditSuccess()
                                    }
                                    self.selectedImg = nil //reset the selected img selector
                                    self.hideIndicator()
                                    self.navigationController?.popViewController(animated: true)

                                }
                                else {
                                    self.hideIndicator()
                                    print("Error updating user details")
                                    return
                                }
                            }
                        }
                        else {
                            self.hideIndicator()
                            print("Error changing profile image!")
                            return
                        }
                    }
                }
            }
        }
        else {
            Model.instance.updateUserDetails(userId: user.userId!, newUsername: newUsername!, newEmail: newEmail!, newProfileImg: user.profileImg!, newInfo: newInfo!) { (success) in
                if success {
                    self.hideIndicator()
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.hideIndicator()
                    print("Error updating user details!")
                    return
                }
            }
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
