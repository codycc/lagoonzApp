//
//  Party.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import Foundation


class Party {
    private var _partyName: String!
    private var _partyDescription: String!
    private var _partyLocation: String!
    private var _partyStartTime: String!
    private var _partyEndTime: String!
    private var _partyImageUrl: String!
    private var _partyHost: String!
    private var _publicParty: Bool!
    private var _partyKey: String!
    private var _pendingRequests: Dictionary<String, Any>!
    private var _attendingUsers: Dictionary<String, Any>!
    
    var partyName: String {
        return _partyName
    }
    
    var partyDescription: String {
        return _partyDescription
    }
    
    var partyLocation: String {
        return _partyLocation
    }
    
    var partyStartTime: String {
        return _partyStartTime
    }
    
    var partyEndTime: String {
        return _partyEndTime
    }
    
    var partyHost: String {
        return _partyHost
    }
    
    var publicParty: Bool {
        return _publicParty
    }
    
    var partyKey: String {
        return _partyKey
    }
    
    var partyImageUrl: String {
        return _partyImageUrl
    }
    
    var pendingRequests: Dictionary<String, Any> {
        return _pendingRequests
    }
    
    var attendingUsers: Dictionary<String, Any> {
        return _attendingUsers
    }
    
    init(partyName:String, partyDescription: String, partyLocation: String, publicParty: Bool, partyStartTime: String, partyEndTime: String, pendingRequests: Dictionary<String, Any>, attendingUsers: Dictionary<String, Any>, partyImageUrl: String, partyHost: String, partyKey: String) {
        self._partyKey = partyKey
        self._partyName = partyName
        self._partyDescription = partyDescription
        self._partyStartTime = partyStartTime
        self._partyEndTime = partyEndTime
        self._publicParty = publicParty
        self._partyLocation = partyLocation
        self._partyImageUrl = partyImageUrl
        self._partyHost = partyHost
        self._pendingRequests = pendingRequests
        self._attendingUsers = attendingUsers
        
    }
    
    init(partyKey: String, partyData: Dictionary<String, Any>) {
        self._partyKey = partyKey
        
        if let partyName = partyData["partyName"] {
            self._partyName = partyName as! String
        }
        
        if let partyDescription = partyData["partyDescription"] {
            self._partyDescription = partyDescription as! String
        }
        
        if let partyStartTime = partyData["partyStartTime"] {
            self._partyStartTime = partyStartTime as! String
        }
        
        if let publicParty = partyData["publicParty"] {
            self._publicParty = publicParty as! Bool
        }
        
        if let partyEndTime = partyData["partyEndTime"] {
            self._partyEndTime = partyEndTime as! String
        }
        
        if let partyLocation = partyData["partyLocation"] {
            self._partyLocation = partyLocation as! String
        }
        
        if let partyImageUrl = partyData["partyImageUrl"] {
            self._partyImageUrl = partyImageUrl as! String
        }
        
        if let partyHost = partyData["partyHost"] {
            self._partyHost = partyHost as! String
        }
        
        if let pendingRequests = partyData["pendingRequests"] {
            self._pendingRequests = pendingRequests as! Dictionary<String, Any>
        }
        
        if let attendingUsers = partyData["attendingUsers"] {
            self._attendingUsers = attendingUsers as! Dictionary<String, Any>
        }
        
    }
}
