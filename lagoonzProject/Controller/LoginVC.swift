//
//  ViewController.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var passwordField: StyledTextField!
    @IBOutlet weak var emailField: StyledTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegates
        emailField.delegate = self
        passwordField.delegate = self
        
        //NOTIFICATIONS FOR MOVING FRAME UP
        
    }
    
    //For keyboard to move view up when typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func signInBtnTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("CODY1: you have successfully signed in ")
                    //Pass user to set keychain function
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                } else {
                    print("CODY1: Something came up and signin was unsuccessful")
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        //After user has successfully logged in go to dashboard
       // performSegue(withIdentifier: GO_TO_REVEAL_VC, sender: nil)
        //Creating a firebase user
        DataService.instance.createFirebaseDBUser(uuid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        //print("CODY1: Data saved to keychain \(keychainResult) ")
        
    }
    


}

