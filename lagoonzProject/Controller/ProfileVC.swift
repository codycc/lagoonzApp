//
//  ProfileVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-30.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func retrieveUserInfo() {
        DataService.instance.REF_CURRENT_USER.observe(.value) { (snapshot) in
            if let userDict = snapshot.value as? Dictionary<String, Any> {
                let key = snapshot.key
                let user = User(userKey: key, userData: userDict)
                print("\(user.email) here is user")
                self.user = user
                self.setLabels()
            }
        }
    }
    
    func setLabels() {
        self.profileName.text = user.name
        let imageUrl = URL(string: user.profilePhotoUrl)!
        
        self.profileImage.kf.setImage(with: imageUrl)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    

}
