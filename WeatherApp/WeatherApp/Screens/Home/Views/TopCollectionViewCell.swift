//
//  TopCollectionViewCell.swift
//  Weather
//
//  Created by Dhruv Ukani on 07/10/23.
//

import UIKit
import TinyConstraints

class TopCollectionViewCell: UICollectionViewCell {
    
    //    MARK: - Properties
    
    static let identifire = TopCollectionViewCell.description()
    //  MARK: - UIComponent
    
    private var weatherTypeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var weatherType : UILabel = {
        labelUI(text: "", 
                textColor: .white,
                textFont: .robotoSlabMedium(size: 15),
                textAlignment: .center,
                isShado: true)
    }()
    
    // MARK: - Intializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetupUI()
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UISetup
    
    private func cellSetupUI(){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
    }
    
    private func setupUI(){
        self.addSubview(weatherTypeImageView)
        self.addSubview(weatherType)
    }
    
    private func setupConstraint(){
        
        weatherTypeImageView.top(to: self)
        weatherTypeImageView.center(in: self)
        weatherTypeImageView.size(CGSize(width: 60, height: 60))
        
        weatherType.topToBottom(of: weatherTypeImageView,offset: -3)
        weatherType.centerX(to: self)
        weatherType.numberOfLines = 1
        weatherType.edgesToSuperview(excluding: [.top,.bottom],insets: TinyEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
    }
    
    //  MARK: - Cell Config
    
    func configContent(weatherType:String,weatherTypeImageName:String){
        self.weatherTypeImageView.image = UIImage(named: weatherTypeImageName)
        self.weatherType.text = weatherType
        
    }
}
