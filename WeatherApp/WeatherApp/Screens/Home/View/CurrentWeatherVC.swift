//
//  ViewController.swift
//  Weather
//
//  Created by Dhruv Ukani on 06/10/23.
//

import UIKit
import CoreLocation
import TinyConstraints

class CurrentWeatherVC: UIViewController {
    
    //  MARK: - Properties
    
    private var currentWeatherVM  : CurrentWeatherVM
    private var forecasrWeatherVM  : ForecastWeatherVM
    private var locationManager : CLLocationManager
    
    //    MARK: - Init
    
    init(_currentWeatherVM : CurrentWeatherVM = CurrentWeatherVM(),
         _forecastWeatherVM : ForecastWeatherVM = ForecastWeatherVM(),
         _locationManager : CLLocationManager = CLLocationManager()){
        currentWeatherVM = _currentWeatherVM
        forecasrWeatherVM = _forecastWeatherVM
        locationManager = _locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - UI Component
    
    private var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 5, right: 13)
        layout.minimumLineSpacing = 30
        layout.estimatedItemSize = CGSize(width: 86, height: 80)
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorConstant.topCollectionColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifire)
        return collectionView
    }()
    
    private var nameLabel: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 30),
                textAlignment: .center,
                isShado: true)
    }()
    
    private var dateLabel: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabLight(size: 15),
                textAlignment: .center,
                isShado: true)
    } ()
    
    private var weatherImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setShadow()
        return imageView
    }()
    
    private var tempLabel: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 70),
                textAlignment: .center,
                isShado: true)
    }()
    
    private var tempSmallLabel: UILabel = {
        labelUI(text: "Temp",
                textColor: .white,
                textFont: .robotoSlabLight(size: 15),
                isShado: true)
    }()
    
    private var tempSmallValue: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont:.robotoSlabMedium(size: 20),
                isShado: true)
    }()
    
    private var humiditySmallLabel: UILabel = {
        labelUI(text: "Humidity",
                textColor: .white,
                textFont:.robotoSlabLight(size: 15),
                isShado: true)
    }()
    
    private var humiditySmallValue: UILabel  = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 20),
                isShado: true)
    }()
    
    private var windSmallLabel: UILabel = {
        labelUI(text: "Wind",
                textColor: .white,
                textFont: .robotoSlabLight(size: 15),
                isShado: true)
    }()
    
    private var windSmallValue: UILabel = {
        labelUI(text: "",
                textColor: .white,
                textFont: .robotoSlabMedium(size: 20),
                isShado: true)
    }()
    
    private var todayLabel: UILabel = {
        labelUI(text: "Today",
                textColor: .white,
                textFont:.robotoSlabLight(size: 20),
                isShado: true)
    }()
    
    private var viewReportButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View Report", for: .normal)
        button.setTitleColor(ColorConstant.vireReportColor, for: .normal)
        button.setShadow(opacity: 1, radius: 4)
        return button
    }()
    
    private var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 17, bottom: 5, right: 13)
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 166 , height: 85)
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorConstant.viewBGC
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BottomCollectionViewCell.self,
                                forCellWithReuseIdentifier: BottomCollectionViewCell.identifire)
        return collectionView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    //  MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = ColorConstant.viewBGC
        locationManager.delegate = self
        setupUI()
        setupConstraint()
        currentWeatherVMObserver()
        forecastVMObserver()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

    }
    //    MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
        //  MARK: - UISetup
    
    private func setupUI(){
        view.addSubview(topCollectionView)
        topCollectionView.dataSource = self
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(weatherImageView)
        view.addSubview(tempLabel)
        view.addSubview(tempSmallLabel)
        view.addSubview(humiditySmallLabel)
        view.addSubview(windSmallLabel)
        view.addSubview(tempSmallValue)
        view.addSubview(humiditySmallValue)
        view.addSubview(windSmallValue)
        view.addSubview(todayLabel)
        view.addSubview(viewReportButton)
        view.addSubview(bottomCollectionView)
        view.addSubview(activityIndicator)
        bottomCollectionView.dataSource = self
        addTargets()
    }
    
    private func addTargets(){
        viewReportButton.addTarget(self, action: #selector(CurrentWeatherVC.viewReportButtonTapped), for: .touchUpInside)
    }
    
    //    MARK: - Applying Constraint
    
    private func setupConstraint(){
        
        topCollectionView.top(to: view.safeAreaLayoutGuide)
        topCollectionView.left(to: view.safeAreaLayoutGuide)
        topCollectionView.right(to: view.safeAreaLayoutGuide)
        topCollectionView.height(100)
        
        nameLabel.centerX(to: view.safeAreaLayoutGuide)
        nameLabel.topToBottom(of: topCollectionView,offset: 23)
        nameLabel.height(40)
        
        dateLabel.centerX(to: view.safeAreaLayoutGuide)
        dateLabel.topToBottom(of: nameLabel)
        dateLabel.height(20)
        
        weatherImageView.centerX(to: view.safeAreaLayoutGuide)
        weatherImageView.topToBottom(of: dateLabel,offset: 5)
        weatherImageView.size(CGSize(width: 155, height: 155))
        
        tempLabel.centerX(to: view.safeAreaLayoutGuide)
        tempLabel.topToBottom(of: weatherImageView)
        tempLabel.height(92)
        
        tempSmallLabel.topToBottom(of: tempLabel,offset: 38)
        tempSmallLabel.centerX(to:view.safeAreaLayoutGuide, offset: -120)
        
        humiditySmallLabel.topToBottom(of: tempLabel,offset: 38)
        humiditySmallLabel.centerX(to:view.safeAreaLayoutGuide)
        
        windSmallLabel.topToBottom(of: tempLabel,offset: 38)
        windSmallLabel.centerX(to:view.safeAreaLayoutGuide,offset: 120)
        
        tempSmallValue.topToBottom(of: tempSmallLabel)
        tempSmallValue.centerX(to:view.safeAreaLayoutGuide,offset: -120)
        
        humiditySmallValue.topToBottom(of: humiditySmallLabel)
        humiditySmallValue.centerX(to:view.safeAreaLayoutGuide)
        
        windSmallValue.topToBottom(of: windSmallLabel)
        windSmallValue.centerX(to:view.safeAreaLayoutGuide,offset: 120)
        
        todayLabel.topToBottom(of: tempLabel,offset: 115)
        todayLabel.left(to: view.safeAreaLayoutGuide,offset: 24)
        
        viewReportButton.topToBottom(of: tempLabel,offset: 115)
        viewReportButton.right(to: view.safeAreaLayoutGuide,offset: -21)
        
        bottomCollectionView.topToBottom(of: todayLabel,offset: 24)
        bottomCollectionView.left(to: view.safeAreaLayoutGuide)
        bottomCollectionView.right(to: view.safeAreaLayoutGuide)
        bottomCollectionView.height(100)
        
        activityIndicator.edgesToSuperview(usingSafeArea: true)
        
    }
    
    //  MARK: - CurrerntWeather VM Observer
    
    private func currentWeatherVMObserver(){
        currentWeatherVM.eventHandler = { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .loading : self?.activityIndicator.startAnimating()
                case .stopLoading : self?.activityIndicator.stopAnimating()
                case .dataLoaded : self?.configCurrentWeatherContent()
                case .error : self?.showAlert(title: "Server Error", message: "Try again after some time")
                }
            }
        }
    }
    
    //  MARK: - Forecast VM Observer
    
    private func forecastVMObserver(){
        forecasrWeatherVM.eventHandler = { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .loading : self?.activityIndicator.startAnimating()
                case .stopLoading : self?.activityIndicator.stopAnimating()
                case .dataLoaded : self?.configForecastContent()
                case .error :
                    self?.showAlert(title: "Server Error", message: "Try again after some time")
                }
            }
        }
    }
    
    //  MARK: - Config CurrerntWeather
    
    private func configCurrentWeatherContent(){
        self.nameLabel.text = currentWeatherVM.currentWeatherDTO?.city
        self.dateLabel.text = currentWeatherVM.currentWeatherDTO?.date
        self.tempLabel.text = currentWeatherVM.currentWeatherDTO?.temp.appending(" C")
        self.windSmallValue.text = currentWeatherVM.currentWeatherDTO?.wind.appending("km/h")
        self.humiditySmallValue.text = currentWeatherVM.currentWeatherDTO?.humidity.appending("%")
        self.tempSmallValue.text = currentWeatherVM.currentWeatherDTO?.temp.appending("c")
        self.weatherImageView.image = UIImage(named: currentWeatherVM.currentWeatherDTO?.icon ?? "")
        self.dateLabel.text = currentWeatherVM.currentWeatherDTO?.date
    }
    
    //  MARK: - Config ForecastData
    
    private func configForecastContent(){
        self.bottomCollectionView.reloadData()
    }
    
    //  MARK: - ConfigData from Sear
    
    func configDataFromSearchVC(data: CurrentWeatherDTO){
        DispatchQueue.main.async {
            self.nameLabel.text           = data.city
            self.dateLabel.text           = data.date
            self.tempLabel.text           = data.temp.appending(" C")
            self.windSmallValue.text      = data.wind.appending("km/h")
            self.humiditySmallValue.text  = data.humidity.appending("%")
            self.tempSmallValue.text      = data.temp.appending("c")
            self.weatherImageView.image   = UIImage(named: data.icon )
            self.dateLabel.text           = data.date
            self.configForecastContent()
        }
    }
    
    //  MARK: - View Report Tapped
    
    @objc func viewReportButtonTapped(){
        let destVC = ForeCastReportVC(_foreCastData: forecasrWeatherVM.getNextFourDaysForcast())
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
}

//  MARK: - CollectionView DataSource

extension CurrentWeatherVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.topCollectionView : return currentWeatherVM.topCollectionViewData.count
        case self.bottomCollectionView : return forecasrWeatherVM.forecastData[0]?.count ?? 0
        default : return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.topCollectionView :
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifire,
                                                                for: indexPath) as? TopCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configContent(weatherType: currentWeatherVM.topCollectionViewData[indexPath.row].0, weatherTypeImageName:currentWeatherVM.topCollectionViewData[indexPath.row].1)
            return cell
            
        case self.bottomCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifire,
                                                                for: indexPath) as? BottomCollectionViewCell  else {
                return UICollectionViewCell()
            }
            switch (indexPath.row%2) {
            case 0 : cell.configContent(forecastDTO: forecasrWeatherVM.forecastData[0]![indexPath.row],
                                        textColor: .white,
                                        cellBGC: ColorConstant.lightBlue)
                
            case 1 :cell.configContent(forecastDTO: forecasrWeatherVM.forecastData[0]![indexPath.row],
                                       textColor: ColorConstant.black,
                                       cellBGC: ColorConstant.frontWhite)
            default : break
            }
            
            return cell
        default : return UICollectionViewCell()
        }
    }
}

//  MARK: - Data From SearchWeatherVC

extension CurrentWeatherVC : SendDataToCurrVC {
    func sendData(data: CurrentWeatherDTO) {
        self.forecasrWeatherVM.getForeCast(location: LocationModel(lat: data.lat, lon: data.lon))
        self.configDataFromSearchVC(data: data)
    }
}

//    MARK: - LocationManager Delegate

extension CurrentWeatherVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations.first?.coordinate.latitude
        let lon = locations.first?.coordinate.longitude
        currentWeatherVM.currentLocation = LocationModel(lat: String(lat!), lon: String(lon!))
        locationManager.stopUpdatingLocation()
        currentWeatherVM.getCurrentWeather(location: currentWeatherVM.currentLocation)
        forecasrWeatherVM.getForeCast(location: currentWeatherVM.currentLocation)
    }
}
