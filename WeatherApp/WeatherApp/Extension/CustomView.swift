//
//  CustomView.swift
//  Weather
//
//  Created by Dhruv Ukani on 07/10/23.
//

import Foundation
import UIKit



func labelUI(text: String?, textColor: UIColor?, textFont: UIFont?, textAlignment: NSTextAlignment? = .natural, isShado: Bool = false) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    if let textTitle = text {
        label.text = textTitle
    }
    if let textColor = textColor {
        label.textColor = textColor
    }
    if let textFont = textFont {
        label.font  = textFont
    }
    if let txA = textAlignment {
        label.textAlignment = txA
    }
    if isShado {
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 5
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    return label
}


func getTime(date:String)->String{
    let stringToDate = DateFormatter()
    stringToDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let originalDate = stringToDate.date(from: date)!
    let dateToTime = DateFormatter()
    dateToTime.timeStyle = .short
    dateToTime.locale = Locale.autoupdatingCurrent
    return dateToTime.string(from: originalDate)
}



