//
//  CreateAccountVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class CreateAccountVC: UIViewController {

    @IBOutlet weak var emailField: StyledTextField!
    @IBOutlet weak var passwordField: StyledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(email)
                    print("CODY1: Unable to create account with firebase using email \(String(describing: error))")
                } else {
                    print("CODY1: Successfully created account with firebase email ")
                    if let user = user {
                        let userData = ["provider": user.providerID,
                                        "profilePhotoUrl": "gs://lagoonzapp.appspot.com/profile-pics/profilePhoto.jpg"]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            })
        }
    }
    
    //Setting keychain
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        //Perform segue
        performSegue(withIdentifier: GO_TO_DASHBOARD_VC_FROM_CREATE , sender: nil)
        
        //Create firebase database user
        DataService.instance.createFirebaseDBUser(uuid: id, userData: userData)
        
        //Store keychain
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("CODY1: Data saved to keychain \(keychainResult)")
    }

    
    
}
