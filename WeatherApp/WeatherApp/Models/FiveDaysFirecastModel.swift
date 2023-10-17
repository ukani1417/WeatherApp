//
//  FiveDaysFirecastModel.swift
//  Weather
//
//  Created by Dhruv Ukani on 06/10/23.
//

import Foundation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FiveDaysFirecastModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [FDFMList]
    let city: FDFMCity
}

// MARK: - City
struct FDFMCity: Codable {
    let id: Int
    let name: String
    let coord: FDFMCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct FDFMCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct FDFMList: Codable {
    let dt: Int
    let main: FDFMMain
    let weather: [FDFMWeather]
    let clouds: FDFMClouds
    let wind: FDFMWind
    let visibility: Int
    let pop: Double
    let rain: FDFMRain?
    let sys: FDFMSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct FDFMClouds: Codable {
    let all: Int
}

// MARK: - Main
struct FDFMMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct FDFMRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct FDFMSys: Codable {
    let pod: String
}

// MARK: - Weather
struct FDFMWeather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct FDFMWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}



