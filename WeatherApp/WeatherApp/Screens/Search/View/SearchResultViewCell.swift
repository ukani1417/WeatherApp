//
//  SearchResultViewCell.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//

import UIKit
import TinyConstraints
class SearchResultViewCell: UICollectionViewCell {
    
    static let identifire = SearchResultViewCell.description()
    
//    MARK: - Components
    
    private let  tempLabel: UILabel = {
        labelUI(text: "",
                textColor: .black,
                textFont: .robotoSlabLight(size: 20),
                textAlignment: .center,isShado: true)
    }()
    
    private let  imageview: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.setShadow()
        return iView
    }()
    
    private let  weatherTypeLabel: UILabel = {
        labelUI(text: "",
                textColor: .black,
                textFont: .robotoSlabLight(size: 18),
                textAlignment: .center,isShado: true)
    }()
    
    private let  cityNameLabel: UILabel = {
        labelUI(text: "",
                textColor: .black,
                textFont: .robotoSlabMedium(size: 25),
                textAlignment: .center,isShado: true)
    }()
    
    
//    MARK: - Intializers
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
        self.backgroundColor = ColorConstant.frontWhite
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
    }
    
    private func setupUI(){
        self.addSubview(tempLabel)
        self.addSubview(imageview)
        self.addSubview(weatherTypeLabel)
        self.addSubview(cityNameLabel)
    }
    
    private func setupConstraint(){
        
        tempLabel.centerX(to: self)
        tempLabel.top(to: self,offset: 22)
        tempLabel.height(22)
        
        imageview.centerX(to: self)
        imageview.topToBottom(of: tempLabel,offset: 1)
        imageview.size(CGSize(width: 80, height: 80))
        
        weatherTypeLabel.centerX(to: self)
        weatherTypeLabel.topToBottom(of: imageview,offset: 1)
        weatherTypeLabel.height(24)
        weatherTypeLabel.edgesToSuperview(excluding: [.top,.bottom],insets: TinyEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
   
        cityNameLabel.centerX(to: self)
        cityNameLabel.topToBottom(of: weatherTypeLabel,offset: 1)
        cityNameLabel.height(26)
        cityNameLabel.edgesToSuperview(excluding: [.top,.bottom],insets: TinyEdgeInsets(top: 0, left: 5, bottom: 0, right: 7))
    }
    
//    MARK: - Config Content
    
    func configContent(currentWeatherDTO:CurrentWeatherDTO,cellBGC:UIColor,cellTextColor:UIColor){
        self.backgroundColor = cellBGC
        tempLabel.text = currentWeatherDTO.temp.appending("c")
        tempLabel.textColor = cellTextColor
        print(currentWeatherDTO)
        imageview.image = UIImage(named: currentWeatherDTO.icon)
        weatherTypeLabel.text = currentWeatherDTO.weatherType
        weatherTypeLabel.textColor = cellTextColor
        cityNameLabel.text = currentWeatherDTO.city
        cityNameLabel.textColor = cellTextColor
    }
}
