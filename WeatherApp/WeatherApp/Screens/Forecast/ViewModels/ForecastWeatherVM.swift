//
//  ForecastWeatherVM.swift
//  Weather
//
//  Created by Dhruv Ukani on 10/10/23.
//

import Foundation

class ForecastWeatherVM {
    
    //    MARK: - Properties
    
    private var repository:Repository
    var forecastData : [Int:[ForecastDTO]]
    var eventHandler :  ((_ event: Event) -> Void)?
    
    //    MARK: - Init
    
    init(_repository: Repository = WeatherRepository(), _forecastData: [Int:[ForecastDTO]] = [:]){
        repository = _repository
        forecastData = _forecastData
    }
    
    //    MARK: - GetForeCast
    
    func getForeCast(location: LocationModel){
        self.eventHandler?(.loading)
        repository.getForecast(location: location) { result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data) :
                self.forecastData = data
                self.eventHandler?(.dataLoaded)
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
    
    //    MARK: - NextFourDaysForecast
    
    func getNextFourDaysForcast()->[Int:[ForecastDTO]]{
        let data  = forecastData.filter { obj in
            obj.key != 0
        }
        var newData = [Int:[ForecastDTO]]()
        data.forEach { (key,val) in
            newData[key-1] = val
        }
        return newData
    }
}

//   MARK: - EventHandler

extension ForecastWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}


