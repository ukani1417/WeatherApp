//
//  ForeCastReportVC.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//

import UIKit
import TinyConstraints



class ForeCastReportVC: UIViewController {
    
    //    MARK: - Properties
    
    private var foreCastData : [Int:[ForecastDTO]]
    
    //    MARK: - Init
    
    init(_foreCastData: [Int:[ForecastDTO]] = [:]){
        foreCastData  =  _foreCastData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK:  - UIComponent
    
    private var topLabel: UILabel = {
        labelUI(text: "Forecast Report",
                textColor: .white,
                textFont:  .robotoSlabMedium(size: 30),
                textAlignment: .center,
                isShado: true)
    }()
    
    private var reportCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 352 , height: 84)
        layout.sectionHeadersPinToVisibleBounds = true
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorConstant.viewBGC
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell   .identifire)
        collectionView.register(ForecastCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ForecastCollectionHeaderView.identifire)
        return collectionView
        
    }()
    
    //    MARK: - Intializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigation()
        self.view.backgroundColor = ColorConstant.viewBGC
        setupUI()
        setupConstraint()
        
    }
    
    //    MARK: - UI Setup
    
    private func showNavigation(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupUI(){
        view.addSubview(topLabel)
        view.addSubview(reportCollectionView)
        reportCollectionView.dataSource = self
        reportCollectionView.delegate = self
    }
    
    private func setupConstraint(){
        topLabel.top(to: view.safeAreaLayoutGuide,offset: 0)
        topLabel.centerX(to: view.safeAreaLayoutGuide)
        topLabel.height(40)
        
        reportCollectionView.topToBottom(of: topLabel,offset: 40)
        reportCollectionView.edgesToSuperview(excluding: [.top],insets: TinyEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),usingSafeArea: true)
    }
}

//  MARK:  -CollectionView Datasource

extension ForeCastReportVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return foreCastData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return (foreCastData[section]?.count ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.congifContent(forecastDTO: foreCastData[indexPath.section]![indexPath.row])
        return cell
    }
}

//  MARK: - CollectionViewDelegateFlowLayout

extension ForeCastReportVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ForecastCollectionHeaderView.identifire, for: indexPath) as?
                    ForecastCollectionHeaderView else {
                return UICollectionReusableView()
            }
            headerView.configContent(day: String(foreCastData[indexPath.section]?.first?.date ??  "Next Day"))
            return headerView
        default :  return UICollectionReusableView()
            
        }
    }
}
