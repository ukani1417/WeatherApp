//
//  WeatherRepository.swift
//  Weather
//
//  Created by Dhruv Ukani on 09/10/23.
//

import Foundation

enum WeatherRepoError : String , Error {
    case cityNotFound = "City not found"
    case serverError = "Server Error"
}

protocol Repository {
    func getCityLocation(city: String,_ completation : @escaping (Result<LocationModel,WeatherRepoError>)->Void)
    func getCurrentWeather(location: LocationModel,_ completation : @escaping (Result<CurrentWeatherDTO,WeatherRepoError>)->Void)
    func getForecast(location: LocationModel,_ completation : @escaping (Result<[Int:[ForecastDTO]],WeatherRepoError>)->Void)
}

class WeatherRepository : Repository {
    //    MARK: - GetLocation
    
    func getCityLocation(city: String,_ completation : @escaping (Result<LocationModel,WeatherRepoError>) ->Void)  {
        
        APIManager.shared.request(apiRouter: WeatherAPIRouter.getCityLocation(city: city), modelType: [City].self) { result in
            switch result {
            case .success(let cityData) :
                if let cityData = cityData.first  {
                    if city == cityData.name {
                        let location = LocationModel(lat: String(cityData.lat), lon: String(cityData.lon))
                        completation(.success(location))
                    }
                    else{
                        completation(.failure(.cityNotFound))
                    }
                }
                else {
                    completation(.failure(.cityNotFound))
                }
             case .failure(let error) :
                debugPrint("GetCityLocation Repo Error : \(error.localizedDescription)")
                completation(.failure(.serverError))
             }
        }
    }
    //    MARK: - GetCurrentWeather
                             
    func getCurrentWeather(location: LocationModel,
                           _ completation : @escaping ((Result<CurrentWeatherDTO,WeatherRepoError>)->Void)) {
         APIManager.shared.request(apiRouter: WeatherAPIRouter.getCurrentWeather(lat: location.lat, lon: location.lon),
                                   modelType: CWResult.self) { result in
                switch result {
                case.success(let weatherResult) :
                    let currentWeatherDTO = CurrentWeatherDTO(weatherType: weatherResult.weather.first?.main ?? "ClearSky",
                                                              city: weatherResult.name,
                                                              temp: String(weatherResult.main.temp),
                                                              humidity: String(weatherResult.main.humidity),
                                                              wind: String(weatherResult.wind.speed),
                                                              icon:weatherResult.weather.first?.icon ?? "01d",
                                                              lat: String(weatherResult.coord.lat),
                                                              lon: String(weatherResult.coord.lon))
                    
                    completation(.success(currentWeatherDTO))
                case .failure(let error) : 
                    debugPrint("GetCurrentWeather Repo Error : \(error.localizedDescription)")
                    completation(.failure(.serverError))
                }
            }
    }
                             
     //    MARK: - GetForecast
                             
     func getForecast(location: LocationModel, _ completation : @escaping ((Result<[Int:[ForecastDTO]],WeatherRepoError>)->Void))  {
                    
                    var responce : [Int:[ForecastDTO]] = [:]
                    
                    APIManager.shared.request(apiRouter: WeatherAPIRouter.getFiveDaysForcast(lat: location.lat, lon: location.lon), modelType: FiveDaysFirecastModel.self) {  forecastResult in
                        
                        
                        switch forecastResult {
                        case .success(let result) :  result.list.forEach { data in
                            
                            let index = self.getKey(day: data.dtTxt)
                            let tempDTO = (ForecastDTO(weatherType: data.weather.first?.main ?? "ClearSky", date: data.dtTxt, temp: data.main.temp ,icon:data.weather.first?.icon ?? "01") )
                            if (responce.keys.contains(index) == true) {
                                responce[index]?.append(tempDTO)
                            }
                            else{
                                responce.updateValue([tempDTO], forKey: index)
                            }
                        }
                            completation(.success(responce))
                        case .failure(let error):
                            debugPrint("GetForecastRepo Error : \(error.localizedDescription)")
                            completation(.failure(.serverError))
                        }
                    }
                }
    //    MARK: - GetDateFromString
                             
     private func getKey(day:String)->Int {
                    
        var calender = Calendar.current
        let timzone = TimeZone.current
        calender.timeZone = timzone
        
        let StringToDate = DateFormatter()
        StringToDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        StringToDate.timeZone = timzone
        
        let fromDateString = StringToDate.string(from: Date())
        let fromDate = StringToDate.date(from: fromDateString)!
        let toDate = StringToDate.date(from: day)!
        
        
        let DateToString = DateFormatter()
        DateToString.dateFormat = "dd-MM-yyyy"
        DateToString.timeZone = timzone
        
        let d1 = DateToString.string(from: fromDate)
        let d2 = DateToString.string(from: toDate)
        
        let v1 = DateToString.date(from: d1)!
        let v2 = DateToString.date(from: d2)!
        
        let days = calender.dateComponents([.day], from: v1,to: v2).day!
        
        return days
    }
                             
}
