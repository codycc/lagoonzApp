//
//  MyPartiesVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Firebase

class MyPartiesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var attendingTableView: UITableView!
    @IBOutlet weak var hostingTableView: UITableView!
    
    var partiesAttending = [Party]()
    var partiesHosting = [Party]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendingTableView.delegate = self
        attendingTableView.dataSource = self
        hostingTableView.delegate = self
        hostingTableView.dataSource = self
        
        self.retrievePartyAttending()
        self.retrievePartyHosting()
        
        // swreveal
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 100
        // Do any additional setup after loading the view.
    }
    
    
    
    func retrievePartyAttending() {
        let user = DataService.instance.REF_CURRENT_USER
        user.child("partiesAttending").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.partiesAttending = []
                
                for snap in snapshot {
                    
                    let partyKey = snap.key
                    let party = DataService.instance.REF_PARTIES.child(partyKey)
                    party.observe(.value, with: { (snapshot) in
                        if let partyDict = snapshot.value as? Dictionary<String, Any> {
                            let key = snapshot.key
                            let party = Party(partyKey: key, partyData: partyDict)
                            self.partiesAttending.append(party)
                            print("\(party) here is party")
                        }
                        
                        self.attendingTableView.reloadData()
                    })
                    
                }
                
            }
        })
    }
    
    func retrievePartyHosting() {
        let user = DataService.instance.REF_CURRENT_USER
        user.child("partiesHosting").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.partiesHosting = []
                for snap in snapshot {
                    print("\(snap)here is the snap ")
                    let partyKey = snap.key
                    let party = DataService.instance.REF_PARTIES.child(partyKey)
                    party.observe(.value, with: { (snapshot) in
                        if let partyDict = snapshot.value as? Dictionary<String, Any> {
                            let key = snapshot.key
                            let party = Party(partyKey: key, partyData: partyDict)
                            self.partiesHosting.append(party)
                        }
                        print("\(self.partiesHosting) here is parties hosting")
                        self.hostingTableView.reloadData()
                    })
                }
            }
        })
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
         print("number of sections table view is being called ")
        if tableView == self.attendingTableView {
            return 1
        } else if tableView == self.hostingTableView {
            return 1
        } else {
            print("returning 0")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows table view is being called ")
        if tableView == self.attendingTableView {
            return partiesAttending.count
        } else if tableView == self.hostingTableView {
            return partiesHosting.count
        } else {
             print("returning 0 sections")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell index path table view is being called ")
        if tableView == self.attendingTableView {
            let party = partiesAttending[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PartyAttendingCell") as? PartyAttendingCell {
                cell.configureCell(party: party)
                print("\(party) here is the party")
                return cell
            } else {
                return PartyAttendingCell()
            }
        } else {
            let party = partiesHosting[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PartyHostingCell") as? PartyHostingCell {
                cell.configureCell(party: party)
                return cell
            } else {
                return PartyHostingCell()
            }
        }
        
    }
    
    @IBAction func createPartyTapped(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_CREATE_PARTY_VC, sender: nil)
    }
    
}
