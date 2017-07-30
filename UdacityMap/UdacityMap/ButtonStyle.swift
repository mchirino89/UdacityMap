//
//  ButtonStyleController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 28/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonStyle: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            return self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            return self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            return self.layer.backgroundColor = borderColor.cgColor
        }
    }    
}
