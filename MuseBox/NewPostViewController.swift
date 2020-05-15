//
//  NewPostViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SignInViewControllerDelegate {
    
    func onSignInSuccess() {
    }
    
    func onSignInCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    

    var selectedImg: UIImage?
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var sharePostBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        photo.addGestureRecognizer(tap)
        handleShareButton() // makes the share button enabled if text fields are filled
        
        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleShareButton()
    }
    
    func handleShareButton(){
        topicTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        interestTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        contactTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldsUpdated(){
        if topicTextField.text!.isEmpty || interestTextField.text!.isEmpty || contactTextField.text!.isEmpty || selectedImg == nil {
            sharePostBtn.isEnabled = false
            return
        }
        sharePostBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        sharePostBtn.isEnabled = true
        
    }
    
    @objc func handleTap() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImg = image
            self.photo.image = image
        }
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func shareBtn_TouchUpInside(_ sender: Any) {
        if topicTextField.text == "" || interestTextField.text == "" || contactTextField.text == "" || contentTextView.text == "" {
            return
        }
        
        showIndicator(title: "Posting...", description: "")
        let newPostId = UUID().uuidString
        let newPost = Post(userId: Model.instance.theUser.userId!,username: Model.instance.theUser.username!,userImgUrl: Model.instance.theUser.profileImg!,topic: topicTextField.text!, interest: interestTextField.text!, contact: contactTextField.text!, content: contentTextView.text!, postId: newPostId)
        Model.instance.savePost(newPost: newPost, postImage: self.photo.image) { (success) in
            
            if success {
                self.hideIndicator()
                self.selectedImg = nil //reset the selected img selector
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.hideIndicator()
                return
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
