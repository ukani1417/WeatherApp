//
//  CurrentWeatherVM.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//

import Foundation
import CoreLocation


class CurrentWeatherVM {
    
    //    MARK: - Properties
    
    var repository: Repository
    var locationManager: CLLocationManager  = CLLocationManager()
    var currentWeatherDTO:  CurrentWeatherDTO?
    var eventHandler: ((_ event: Event) -> Void)?
    var currentLocation : LocationModel!
    var topCollectionViewData : [(String, String)] = [
        ("Clear Sky","01"),
        ("few clouds","02"),
        ("scattered clouds","02"),
        ("broken clouds","04"),
        ("shower rain","09"),
        ("rain","10"),
        ("thunderstorm","11"),
        ("snow","13"),
        ("mist","50"),
    ]
    
    //    MARK:  - Inti
    
    init(_repository: Repository = WeatherRepository()){
        repository = _repository
    }
    
    //  MARK: - Current Weather
    
    func getCurrentWeather(location: LocationModel){
        self.eventHandler?(.loading)
        self.repository.getCurrentWeather(location: location) { result  in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data) :
                self.currentWeatherDTO = data
                self.eventHandler?(.dataLoaded)
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
}

//  MARK: - EventHandler
extension CurrentWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}
