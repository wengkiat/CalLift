//
//  ColoredButton.swift
//  CalLift
//
//  Created by Leon Mak on 30/9/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class ColoredButton: UIButton {
    convenience init(frame: CGRect, color: UIColor, borderColor: UIColor=UIColor.black) {
        self.init(frame: frame)
        self.backgroundColor = color
        self.layer.borderColor = borderColor.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6
        
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.borderWidth = 0
        
        self.setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

