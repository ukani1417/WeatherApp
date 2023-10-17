//
//  ViewExtention.swift
//  Weather
//
//  Created by Dhruv Ukani on 13/10/23.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(title: String, message: String){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
          })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
