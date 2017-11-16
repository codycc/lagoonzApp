//
//  SendPartyRequestVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class SendPartyRequestVC: UIViewController {
    
    @IBOutlet weak var partyImageView: CircleView!
    
    @IBOutlet weak var partyTitleLbl: UILabel!
    
    var party: Party!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        // Do any additional setup after loading the view.
    }
    
    func setLabels() {
        let imageUrl = URL(string: party.partyImageUrl)!
        partyImageView.kf.setImage(with: imageUrl, options: [.onlyFromCache])
        self.partyTitleLbl.text = party.partyName
    }
    

    @IBAction func sendPartyRequestTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let partyKey = party.partyKey
        let userKey = DataService.instance.REF_CURRENT_USER.key
        DataService.instance.REF_PARTIES.child(partyKey).child("pendingRequests").child(userKey).setValue(true)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
