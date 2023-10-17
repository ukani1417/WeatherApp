//
//  BottomCollectionViewCell.swift
//  Weather
//
//  Created by Dhruv Ukani on 07/10/23.
//

import UIKit
import TinyConstraints
class BottomCollectionViewCell: UICollectionViewCell {
    static let identifire = BottomCollectionViewCell.description()
    
    //  MARK: - UIComponent
    
    private let insideView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var weatherImageView : UIImageView  = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()
    
    private var timeLabel: UILabel = {
        labelUI(text: "",
                textColor: ColorConstant.black,
                textFont: .robotoSlabMedium(size: 12))
    }()
    
    private var tempLabel: UILabel = {
        labelUI(text: "",
                textColor: ColorConstant.black  ,
                textFont: .robotoSlabMedium(size: 17))
    }()
    
    //  MARK: - Intializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetupUI()
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - UISetup
    
    private func cellSetupUI(){
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupUI(){
        insideView.addSubview(timeLabel)
        insideView.addSubview(tempLabel)
        self.addSubview(weatherImageView)
        self.addSubview(insideView)
    }
    
    private func setupConstraint(){
        
        timeLabel.leading(to: insideView,offset: 10)
        timeLabel.centerY(to: insideView,offset: -10)
        
        tempLabel.leading(to: insideView,offset: 10)
        tempLabel.centerY(to: insideView,offset: 10)
        
        weatherImageView.size(CGSize(width: 70, height:70))
        weatherImageView.left(to: self,offset: 10)
        weatherImageView.centerY(to: self)
        
        insideView.size(CGSize(width: self.frame.width-100, height:  self.frame.height-5))
        insideView.leftToRight(of: weatherImageView,offset: 1)
        insideView.centerY(to: self)
        
    }
    
    //  MARK: - Cell Config
    func configContent(forecastDTO:ForecastDTO,textColor:UIColor,cellBGC:UIColor){
        self.backgroundColor = cellBGC
        weatherImageView.image = UIImage(named: forecastDTO.icon)
        timeLabel.text = forecastDTO.time
        tempLabel.text = forecastDTO.temp
        timeLabel.textColor = textColor
        tempLabel.textColor = textColor
    }
    
}
