//
//  DataService.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    //Creating a new user in the database
    func createFirebaseDBUser(uuid: String, userData: Dictionary<String, String>) {
        //Creating the user using the uid
        REF_USERS.child(uuid).updateChildValues(userData)
    }
    
}
