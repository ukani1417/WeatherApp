//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Dhruv Ukani on 06/10/23.
//

import Foundation

// Current Weather : - city,date(month day , year) temp , wind , himidity ,

struct CWResult: Codable {
    let coord: Coord
    let weather: [WeatherType]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity : Int
    let seaLevel , grndLevel : Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let  id: Int?
    let country: String
    let sunrise, sunset: Int
    let type: Int?
}

//  MARK: - Weather
struct WeatherType: Codable {
    let id: Int?
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}


// MARK: - City
struct City: Codable {
    let name: String
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
}


