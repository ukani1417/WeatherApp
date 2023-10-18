//
//  CDCurrentWeatherDTO.swift
//  WeatherApp
//
//  Created by Dhruv Ukani on 18/10/23.
//

import Foundation

extension CDCurrentWeatherDTO {
    func toConvert()->CurrentWeatherDTO {
        return CurrentWeatherDTO(weatherType: self.weatherType!,
                                 city: self.city!,
                                 temp: self.temp!,
                                 humidity: self.humidity!,
                                 wind: self.wind!,
                                 icon: self.icon!+"d",
                                 lat: self.lat!,
                                 lon: self.lon!)
    }
}
