//
//  SearchWeatherVC.swift
//  Weather
//
//  Created by Dhruv Ukani on 07/10/23.
//

import UIKit
import TinyConstraints

protocol SendDataToCurrVC{
    func sendData(data: CurrentWeatherDTO)
}

class SearchWeatherVC: UIViewController {
    
    //  MARK: - Properties
    
    private var searchWeatherVM = SearchWeatherVM()
    var delegate: SendDataToCurrVC?
    
    
    //  MARK: - UIComponent
    
    private let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
        
    }()
    
    private let topFirstLabel: UILabel = {
        labelUI(text: "Pick a location",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 30),
                textAlignment: .center)
    }()
    
    private let topSecondLabel: UILabel = {
        let label = labelUI(text: "Type the area or city you want to know the \n detailed weather information at \n this time.", 
                            textColor: .white,
                            textFont: .robotoSlabLight(size: 15),
                            textAlignment: .center)
        label.numberOfLines = 0
        return label
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorConstant.lightBlue
        view.clipsToBounds  = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        return view
        
    }()
    
    private let txtSearchField: UITextField = {
        let searchBar = UITextField( )
        let placeholderText = "Search"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorConstant.frontWhite,
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.attributedPlaceholder = attributedPlaceholder
        searchBar.textColor = .white
        return searchBar
    }()
    
    private let searchIconView: UIImageView = {
        let iView = UIImageView(image: UIImage(named: "search 1"))
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFit
        return iView
    }()
    
    private let searchResultView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 162, height: 200)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing  = 17
        
        let collectionView = UICollectionView( frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorConstant.viewBGC
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SearchResultViewCell.self, forCellWithReuseIdentifier: SearchResultViewCell.identifire)
        return collectionView
    }()
    
    //  MARK: - Intializer
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConstant.viewBGC
        setupUI()
        setupConstraint()
        observeEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchWeatherVM.getAllCity()
        self.configContent()
    }
    
    //  MARK: - UISetup
    
    private func setupUI(){
        view.addSubview(topFirstLabel)
        view.addSubview(topSecondLabel)
        searchView.addSubview(txtSearchField)
        searchView.addSubview(searchIconView)
        view.addSubview(searchView)
        txtSearchField.delegate = self
        view.addSubview(searchResultView)
        searchResultView.delegate = self
        searchResultView.dataSource = self
        view.addSubview(activityIndicator)
    }
    
//    MARK: - Constraint
    private func setupConstraint(){
        
        topFirstLabel.centerX(to: view)
        topFirstLabel.top(to: view,offset: 45)
        topFirstLabel.height(40)
        
        topSecondLabel.centerX(to: view)
        topSecondLabel.topToBottom(of: topFirstLabel,offset: 0)
        topSecondLabel.height(60)
        
        searchView.topToBottom(of: topSecondLabel,offset: 21)
        searchView.left(to: view,offset: 30)
        searchView.right(to: view,offset: -30)
        searchView.height(70)
        
        txtSearchField.edgesToSuperview(insets: TinyEdgeInsets(top: 1, left: 20, bottom: 1, right: 30))
        
        searchIconView.edgesToSuperview(excluding: [.left],insets: TinyEdgeInsets(top: 1, left: 0, bottom: 1, right: 15))
        
        searchResultView.topToBottom(of: txtSearchField,offset: 31)
        searchResultView.edgesToSuperview(excluding: [.top],insets: TinyEdgeInsets(top: 0, left: 15, bottom: 10, right: 15),usingSafeArea: true)
        
        activityIndicator.edgesToSuperview(usingSafeArea: true)
    }
    
//    MARK: - Observer For SearchVM
    
    func observeEvent() {
        searchWeatherVM.eventHandler = { [weak self] event in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch event {
                case .loading: self.activityIndicator.startAnimating()
                case .stopLoading :  self.activityIndicator.stopAnimating()
                case .dataLoaded :   self.configContent()
                case .error(let errorMessage):
                    if errorMessage == "City not found" {
                        self.showAlert(title: "", message: "City not found!" )
                    }
                    else{
                        self.showAlert(title: "Server Error", message: "Try again after some time" )
                    }
                }
            }
        }
    }
    
//    MARK: - Config Content
    
    private func configContent(){
        self.searchResultView.reloadData()
    }
}

//  MARK: - Searchtext Field Delegate

extension SearchWeatherVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let city = textField.text?.trimmingCharacters(in: .whitespaces){
            searchWeatherVM.getCityLocation(city: city)
        }
        return true
    }
}

// MARK: - CollectionView Delegate

extension SearchWeatherVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchWeatherVM.searchResults[indexPath.row]
        delegate?.sendData(data: data)
        self.tabBarController?.selectedIndex = 0
        
    }
}

//  MARK:  - CollectionView Datasource

extension SearchWeatherVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchWeatherVM.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultViewCell.identifire, for: indexPath) as? SearchResultViewCell
        else{
            return UICollectionViewCell()
        }
        
        switch indexPath.row {
        case 0 :  cell.configContent(currentWeatherDTO: searchWeatherVM.searchResults[indexPath.row],cellBGC: ColorConstant.lightBlue,cellTextColor: ColorConstant.frontWhite)
        default :  cell.configContent(currentWeatherDTO: searchWeatherVM.searchResults[indexPath.row],cellBGC: ColorConstant.frontWhite,cellTextColor: ColorConstant.black)
        }
        return cell
    }
}

