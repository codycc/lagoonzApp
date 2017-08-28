//
//  StyledButton.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit

@IBDesignable
class StyledButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }

}
