//
//  AttendingUserCell.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-29.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit
import Kingfisher

class AttendingUserCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: CircleView!
    
    
    
    func configureCell(user: User) {
        let imageUrl = URL(string: user.profilePhotoUrl)
        self.userImage.kf.setImage(with: imageUrl)
    }
    
}
