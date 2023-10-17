//
//  ButtonExtension.swift
//  Weather
//
//  Created by Dhruv Ukani on 13/10/23.
//

import Foundation
import UIKit


extension UIButton {
    
    func setShadow(opacity: Float, radius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
}
