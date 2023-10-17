//
//  ForecastCollectionHeaderView.swift
//  Weather
//
//  Created by Dhruv Ukani on 12/10/23.
//

import UIKit
import TinyConstraints
class ForecastCollectionHeaderView: UICollectionReusableView {
    
    //    MARK: - Properties
    static let identifire = ForecastCollectionHeaderView.description()
    
    //    MARK: - UIComponent
    
    private let dayButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  20
        button.clipsToBounds = false
        button.backgroundColor = .white
        button.setTitleColor( ColorConstant.lightBlue, for: .normal)
        return button
    }()
    
    //    MARK: - Init
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
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func setupUI(){
        self.addSubview(dayButton)
    }
    
    private func setupConstraint(){
        dayButton.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
        dayButton.sizeThatFits(self.frame.size)
    }
    
    //    MARK: - ConfigContent
    func configContent(day:String){
        dayButton.setTitle(dateTodat(date: day), for: .normal)
        
    }
    
    private func dateTodat(date:String)->String{
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateformater.date(from: date)!
        return currentDate.toWeekDay().appending(" | ").appending(currentDate.toMediumStyle())
    }
    
}
