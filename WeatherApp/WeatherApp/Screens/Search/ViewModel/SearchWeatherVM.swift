//
//  SearchWeatherVM.swift
//  Weather
//
//  Created by Dhruv Ukani on 09/10/23.
//

import Foundation

class SearchWeatherVM {
    
    //   MARK: - Properties
    var repository : Repository
    var coreRepository : CoreRepo
    var searchResults : [CurrentWeatherDTO] = []
    var eventHandler: ((_ event: Event) -> Void)?
    
    //   MARK: - Init
    
    init(_repository: Repository = WeatherRepository(),
         _coreReporitory: CoreRepo = CDWeatherRepository()){
        repository = _repository
        coreRepository = _coreReporitory
    }
    
    //    MARK: - Methods
    
    func getAllCity(){
        let responce = coreRepository.getList()
        switch responce {
        case .success(let data) : self.searchResults = data
        }
    }

    
//City
//        1.Exist
//            1.1 getWeather
//                1.1.1 update in core
//                    1.1.1.1 true
//                    1.1.1.2 error
//            1.2 error
//        2.Get Location
//            2.1 getWeather
//                    2.1.1 saved in core
//                        2.1.1.1 true
//                        2.1.1.1 error
//            2.2 error
    
    
    func getCityLocation(city: String){
        self.eventHandler?(.loading)
        if let index = self.searchResults.firstIndex(where: { $0.city == city}) {
            self.getWeather(location: LocationModel(lat: self.searchResults[index].lat,
                                                    lon: self.searchResults[index].lon),
                                                    index: index)
            self.eventHandler?(.dataLoaded)
        }
        else{
            repository.getCityLocation(city: city) { result in
                switch result {
                case .success(let data) :
                    self.getWeather(location: data, index: nil)
                case .failure(let error) :
                    self.eventHandler?(.stopLoading)
                    self.eventHandler?(.error(error.rawValue))
                }
            }
        }
    }
    
    func getWeather(location: LocationModel, index: Int?){
        self.eventHandler?(.loading)
        repository.getCurrentWeather(location: location) { result in
            switch result {
            case .success(let data) :
                if let newIndex = index {
                    let responce = self.coreRepository.update(currentWeatherDTO: data)
                    self.eventHandler?(.stopLoading)
                    switch responce {
                    case .success(let ans) :
                        if ans == true {
                            self.searchResults[newIndex] = data
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let coreError) :
                        self.eventHandler?(.error(coreError.rawValue))
                    }
                }
                else{
                    let responce = self.coreRepository.create(currentWeatherDTO: data)
                    self.eventHandler?(.stopLoading)
                    switch responce {
                    case .success(let ans) :
                        if ans == true {
                            self.searchResults.insert(data, at: 0)
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let coreError) :
                        self.eventHandler?(.error(coreError.rawValue))
                    }
                }
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
}

extension SearchWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}
