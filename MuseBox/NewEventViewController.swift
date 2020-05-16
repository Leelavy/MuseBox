//
//  NewEventViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SignInViewControllerDelegate {
    
    func onSignInSuccess() {
    }
    
    func onSignInCancel() {
         self.navigationController?.popViewController(animated: true)
    }
    
    var selectedImg: UIImage?

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var shareEventBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        eventImg.addGestureRecognizer(tap)
        handleShareButton() // makes the share button enabled if text fields are filled
        
        if(!Model.instance.isSignedIn()){
            let signInScreen = SignInViewController.factory()
            signInScreen.delegate = self
            show(signInScreen, sender: self)
        }
    }
    
    func handleShareButton(){
        eventNameTextField.addTarget(self, action: #selector(NewEventViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        dateTextField.addTarget(self, action: #selector(NewEventViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        timeTextField.addTarget(self, action: #selector(NewEventViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        locationTextField.addTarget(self, action: #selector(NewEventViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
        
    }
    @objc func textFieldsUpdated(){
        if eventNameTextField.text!.isEmpty || dateTextField.text!.isEmpty || timeTextField.text!.isEmpty || locationTextField.text!.isEmpty || selectedImg == nil {
            shareEventBtn.isEnabled = false
            return
        }
        shareEventBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        shareEventBtn.isEnabled = true
        
    }
    
    @objc func handleTap() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImg = image
            self.eventImg.image = image
        }
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func shareEventBtn_TouchUpInside(_ sender: Any) {
        
        showIndicator(title: "Sharing Event...", description: "")
        let newEventId = UUID().uuidString
        let newEvent = Event(eventId: newEventId, userId: Model.instance.theUser.userId!, eventName: eventNameTextField.text!, date: dateTextField.text!, time: timeTextField.text!, location: locationTextField.text!, description: descriptionTextView.text!)
        Model.instance.saveEvent(newEvent: newEvent, eventImage: self.eventImg.image) { (success) in
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
