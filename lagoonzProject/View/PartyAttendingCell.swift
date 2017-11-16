//
//  PartyAttendingCell.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit


class PartyAttendingCell: UITableViewCell {

    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var partyNameLbl: UILabel!
    
    var party: Party!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(party: Party) {
        //let imageUrl = URL(string: item.imageUrl)!
        //self.itemImg.kf.setImage(with: imageUrl)
        print("\(party.partyName) here is party name from cell ")
        self.partyNameLbl.text = party.partyName
    }


}
