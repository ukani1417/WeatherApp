//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//

import UIKit
import TinyConstraints

class ForecastCollectionViewCell: UICollectionViewCell {
    
    //    MARK: - Properties
    
    static let identifire = ForecastCollectionViewCell.description()
    
    //    MARK:  - UIComponent
    
    private var timeLabel: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabLight(size: 15),
                textAlignment: .center)
    }()
    
    private var tempLabel: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 36),
                textAlignment: .center)
    }()
    
    private var weatherTypeImageView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()
    
    //    MARK:  - Intializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetupUI()
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - UISetup
    
    private func cellSetupUI(){
        self.backgroundColor =  ColorConstant.lightBlue
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupUI(){
        self.addSubview(timeLabel)
        self.addSubview(tempLabel)
        self.addSubview(weatherTypeImageView)
    }
    
    private func setupConstraint(){
        
        timeLabel.centerX(to: self,offset: -120)
        timeLabel.centerY(to: self,offset: 0)
        timeLabel.height(47)
        
        tempLabel.centerX(to: self,offset: 0)
        tempLabel.centerY(to: self,offset: 0)
        tempLabel.height(47)
        
        weatherTypeImageView.centerX(to: self,offset: 120)
        weatherTypeImageView.centerY(to: self,offset: 0)
        weatherTypeImageView.size(CGSize(width: 80, height: 80))
    }
    
    //    MARK: - Cell Config
    
    func congifContent(forecastDTO:ForecastDTO){
        self.timeLabel.text = forecastDTO.time
        self.tempLabel.text = forecastDTO.temp
        self.weatherTypeImageView.image = UIImage(named:  forecastDTO.icon)
    }
}
