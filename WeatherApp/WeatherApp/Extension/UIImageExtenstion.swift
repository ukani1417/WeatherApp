//
//  UIImageExtenstion.swift
//  Weather
//
//  Created by Dhruv Ukani on 13/10/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setShadow(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
    }
}
