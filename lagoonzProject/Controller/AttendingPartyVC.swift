//
//  AttendingPartyVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-29.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Kingfisher

class AttendingPartyVC: UIViewController {
    
    @IBOutlet weak var partyImageView: CircleView!
    @IBOutlet weak var partyNameLbl: UILabel!
    
    var party: Party!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLabels()
        // Do any additional setup after loading the view.
    }
    
    func setLabels() {
        let imageUrl = URL(string: party.partyImageUrl)!
        partyImageView.kf.setImage(with: imageUrl, options: [.onlyFromCache])
        self.partyNameLbl.text = party.partyName
    }

    @IBAction func attendingPartyTapped(_ sender: Any) {
        let partyKey = party.partyKey
        let userKey = DataService.instance.REF_CURRENT_USER.key
        DataService.instance.REF_PARTIES.child(partyKey).child("attendingUsers").child(userKey).setValue(true)
    }
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
