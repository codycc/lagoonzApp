//
//  User.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-29.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import Foundation

class User {
    private var _email: String!
    private var _partiesAttending: Dictionary<String, Any>!
    private var _partiesHosting: Dictionary<String,Any>!
    private var _profilePhotoUrl: String!
    private var _userKey: String!
    private var _age: Int!
    private var _fbID: String!
    private var _name: String!

    
    
    var email: String {
        return _email
    }
    
    var partiesAttending: Dictionary<String, Any> {
        return _partiesAttending
    }
    
    var partiesHosting: Dictionary<String,Any> {
        return _partiesHosting
    }
    
    var profilePhotoUrl: String {
        return _profilePhotoUrl
    }
    
    var userKey: String {
        return _userKey
    }
    
    var age: Int {
        return _age
    }
    
    var fbID: String {
        return _fbID
    }
    
    var name: String {
        return _name
    }
    
    init(userKey: String, email: String, partiesAttending: Dictionary<String, Any>, partiesHosting: Dictionary<String, Any>, profilePhotoUrl: String, age: Int, fbID: String, name: String) {
        self._email = email
        self._partiesAttending = partiesAttending
        self._partiesHosting = partiesHosting
        self._profilePhotoUrl = profilePhotoUrl
        self._userKey = userKey
        self._age = age
        self._fbID = fbID
        self._name = name
    }
    
    init(userKey: String, userData: Dictionary<String, Any>) {
        self._userKey = userKey
        
        if let email = userData["email"] {
            self._email = email as! String
        }
        
        if let partiesAttending = userData["partiesAttending"] {
            self._partiesAttending = partiesAttending as! Dictionary<String, Any>
        }
        
        if let partiesHosting = userData["partiesHosting"] {
            self._partiesHosting = partiesHosting as! Dictionary<String, Any>
        }
        
        if let profilePhotoUrl = userData["profilePhotoUrl"] {
            self._profilePhotoUrl = profilePhotoUrl as! String
        }
        
        if let age = userData["age"] {
            self._age = age as! Int
        }
        
        if let fbID = userData["fbID"] {
            self._fbID = fbID as! String
        }
        
        if let name = userData["name"] {
            self._name = name as! String 
        }
    }
    
}
