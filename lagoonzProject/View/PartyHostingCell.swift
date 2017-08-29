//
//  PartyHostingCell.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Kingfisher

class PartyHostingCell: UITableViewCell {

    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var partyNameLbl: UILabel!
    
    var party: Party!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(party: Party) {
        let imageUrl = URL(string: party.partyImageUrl)!
        self.partyImage.kf.setImage(with: imageUrl)
        self.partyNameLbl.text = party.partyName
        print("\(party.partyName) here is party name from cell ")
    }

}
