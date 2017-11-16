//
//  PartyVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-29.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class PartyVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var partyNameLbl: UILabel!
    @IBOutlet weak var partyDateLbl: UILabel!
    @IBOutlet weak var partyLocationLbl: UILabel!
    @IBOutlet weak var partyImage: UIImageView!

    
    var party: Party!
    var attendingUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        tableView.delegate = self
//        tableView.dataSource = self
        
        self.retrieveAttendingUsers()
//        self.retrieveAndSetHost()
        setLabels()

    }
    
//
//    func retrieveAndSetHost() {
//        let hostKey = self.party.partyHost
//        DataService.instance.REF_USERS.child(hostKey).child("profilePhotoUrl").observe(.value) { (snapshot) in
//            let hostsProfileUrl = snapshot.value
//            let imageUrl = URL(string: hostsProfileUrl as! String)!
//            self.hostImage.kf.setImage(with: imageUrl)
//        }
//
//    }
    
    func retrieveAttendingUsers() {
        self.attendingUsers = []
        for user in party.attendingUsers {
            let userKey = user.key
            print("\(userKey) here is userkey")
            DataService.instance.REF_USERS.child(userKey).observe(.value, with: { (snapshot) in
                if let userDict = snapshot.value as? Dictionary<String, Any> {
                    let key = snapshot.key
                    let user = User(userKey: key, userData: userDict)
                    print("\(user.email) here is user")
                    self.attendingUsers.append(user)
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    func setLabels() {
        let imageUrl = URL(string: party.partyImageUrl)!
        print("downloading or caching image")
        self.partyImage.kf.setImage(with: imageUrl)
        
        
        
        self.partyNameLbl.text = party.partyName
        self.partyLocationLbl.text = party.partyLocation
        self.partyDateLbl.text = party.partyStartTime
        print("\(party.attendingUsers)")
        
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }
//
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendingUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = attendingUsers[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendingUserCell", for: indexPath) as? AttendingUserCell {
            
            cell.configureCell(user: user)
            return cell
        } else {
            return AttendingUserCell()
        }
    }
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
