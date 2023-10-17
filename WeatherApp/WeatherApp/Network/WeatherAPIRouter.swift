//
//  WeatherAPIRouter.swift
//  Weather
//
//  Created by Dhruv Ukani on 06/10/23.
//

import Foundation


enum Constant {
    static let  HOST = "api.openweathermap.org"
    static let  WeatherSchema = "https"
    static let  GeoSchema = "https"
    static let  APIKey = "e9695ff7350f210bbfcabbd93f542844"
    static let currentWeatherPath = "/data/2.5/weather"
    static let fiveDaysForecastpath = "/data/2.5/forecast"
    static let geoPath = "/geo/1.0/direct"
}

enum WeatherAPIRouter : APIRouter {
    
    case getCurrentWeather(lat:String,lon:String)
    case getCityLocation(city:String)
    case getFiveDaysForcast(lat:String,lon:String)
    
    var host: String {
        switch self {
        case .getCityLocation,
             .getCurrentWeather,
             .getFiveDaysForcast : return Constant.HOST
        
        }
    }
    
    var schema: String {
        switch self {
        case .getCityLocation   ,
                .getCurrentWeather ,
                .getFiveDaysForcast  :return "https"
        }
    }
    
    var path: String {
        switch self {
        case .getCityLocation     : return Constant.geoPath
        case .getCurrentWeather   :  return Constant.currentWeatherPath
        case .getFiveDaysForcast  : return Constant.fiveDaysForecastpath
        }
    }
    
    var methode: String {
        switch self{
        case .getCityLocation,
             .getCurrentWeather ,
             .getFiveDaysForcast : return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getCurrentWeather(let lat, let lon) : return  [URLQueryItem(name: "lat", value: lat),
                                                             URLQueryItem(name: "lon", value: lon),
                                                             URLQueryItem(name: "appid", value: Constant.APIKey),
        URLQueryItem(name: "units", value: "metric"),]
                                                   
        case .getCityLocation(let city) : return [URLQueryItem(name: "q", value: city),
                                                  URLQueryItem(name: "limit", value: "1"),
                                                  URLQueryItem(name: "appid", value: Constant.APIKey)]
            
        case .getFiveDaysForcast(let lat,let lon) : return [URLQueryItem(name: "lat", value: lat),
                                                            URLQueryItem(name: "lon", value: lon),
                                                            URLQueryItem(name: "appid", value: Constant.APIKey),
                                                            URLQueryItem(name: "units", value: "metric"),]
        }
    }
    
    var headers: [(String, String)] {
        switch self {
        case .getCurrentWeather , 
             .getCityLocation ,
             .getFiveDaysForcast : return [("Content-Type","application-json")]
        }
    }
    
    var statusCode: Int {
        switch self {
        case .getCityLocation,.getCurrentWeather ,.getFiveDaysForcast: return 200
        }
    }
    
    var body: Codable? {
        switch self {
        case  .getCurrentWeather,
              .getCityLocation ,
              .getFiveDaysForcast: return nil
        }
    }
    
    
}
