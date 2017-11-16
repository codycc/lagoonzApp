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
import FBSDKCoreKit
import FBSDKLoginKit


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
    
    override func viewDidAppear(_ animated: Bool) {
        //Checking if keychain exists
        //Uncomment to test login screen
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: GO_TO_DASHBOARD_VC_FROM_LOGIN , sender: nil )
        }
    }
    
    //For keyboard to move view up when typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func fbButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in
            if error != nil {
                print("CODY!: UNABLE TO AUTHENTICATE WITH FACBEOOK - \(String(describing: error)) ")
            } else if result?.isCancelled == true {
                print("cody: user cancelled fabceook authentication")
            } else {
                print("cody: Successfully authenticated with facbeook ")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, age_range, gender, picture.width(500).height(500)"])
                graphRequest.start(completionHandler: { (connection, result, error) in
                    if ((error) != nil) {
                        print("Error: \(String(describing: error))")
                    } else if error == nil {
                        let resultDict = result as? Dictionary<String, AnyObject>
                        print("\(resultDict)")
                        if resultDict != nil {
                            let id = resultDict!["id"] as! String
                            let email = resultDict!["email"] as! String
                            let name = resultDict!["name"] as! String
                            let picture = resultDict!["picture"] as! Dictionary<String, Any>
                            let pictureData = picture["data"] as! Dictionary<String, Any>
                            let pictureUrl = pictureData["url"] as! String
                            
                            let age_range = resultDict!["age_range"] as! Dictionary<String, Any>
                            let age_group = age_range["min"] as! Int
                        
                            
                            let userDict: Dictionary<String, Any> = [
                            "fbID": id,
                            "email": email,
                            "name": name,
                            "profilePhotoUrl": pictureUrl,
                            "age": age_group]
                            
                            self.firebaseAuth(credential, userDict)
                        } else {
                            print("Result dictionary is nil\(String(describing: error))")
                        }
                        
                        
                    }
                })

            }
        }
    }
    func firebaseAuth(_ credential: AuthCredential, _ fbUserInfo: Dictionary<String, Any>) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("CODY: Unable to authenticate with firebase -\(String(describing: error))")
            } else {
                print("CODY: Successfully authenticated with firebase ")
                
                //creating firebase db user
                if let user = user {
                    self.completeSignIn(id: user.uid, userData: fbUserInfo)
                }
                
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String,Any>) {
        print("\(userData) here IS THE USER DATA ")
        //After user has successfully logged in go to dashboard
         performSegue(withIdentifier: GO_TO_DASHBOARD_VC_FROM_LOGIN, sender: nil)
        //Creating a firebase user
        DataService.instance.createFirebaseDBUser(uuid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("CODY1: Data saved to keychain \(keychainResult) ")
        
    }
    
    @IBAction func createAccountBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_CREATE_ACCOUNT_VC, sender: nil)
    }
    

}

