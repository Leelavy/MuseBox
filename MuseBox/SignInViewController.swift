//
//  SignInViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate {
    func onSignInSuccess();
    func onSignInCancel();
}

class SignInViewController: UIViewController {

    var delegate:SignInViewControllerDelegate?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInResponse: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    static func factory()->SignInViewController{
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = newBackButton
        
        handleSignInButton()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        //performSegue(withIdentifier: "cancelLoginSegue", sender: self)
        self.navigationController?.popViewController(animated: true);

        if let delegate = delegate{
            delegate.onSignInCancel()
        }
    }
    
    @IBAction func signInBtn_TouchUpInside(_ sender: Any) {
        
        loader.isHidden = false
        Model.instance.signIn(email: emailTextField.text!, password: passwordTextField.text!) { (success) in
            if (success){
                self.navigationController?.popViewController(animated: true)
                //self.navigationController?.popViewController(animated: true);
                if let delegate = self.delegate{
                    delegate.onSignInSuccess()
                }
            }
            else {
                self.loader.isHidden = true
                self.signInResponse.text = "Sign in failed. Please try again"
            }
        }
    }
    
    func handleSignInButton(){
           emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
           passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsUpdated), for: UIControl.Event.editingChanged)
       }
       
       @objc func textFieldsUpdated(){
           if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
               signInBtn.isEnabled = false
               return
           }
           signInBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
           signInBtn.isEnabled = true
           
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
