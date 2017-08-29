//
//  DataService.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper 


let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    //database
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_PARTIES = DB_BASE.child("parties")
    
    //storage
    private var _REF_PARTY_IMAGES = STORAGE_BASE.child("party-pics")
    
    
    //database
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_PARTIES: DatabaseReference {
        return _REF_PARTIES
    }
    
    var REF_CURRENT_USER: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    //storage
    var REF_PARTY_IMAGES: StorageReference {
        return _REF_PARTY_IMAGES
    }
    
    
    //Creating a new user in the database
    func createFirebaseDBUser(uuid: String, userData: Dictionary<String, String>) {
        //Creating the user using the uid
        REF_USERS.child(uuid).updateChildValues(userData)
    }
    
}
