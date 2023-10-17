//
//  ForecastDTO.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//




import Foundation

struct forecastByDays {
    let date: String
    var data: [ForecastDTO]
}

struct ForecastDTO {
    let date:String
    let weatherType:String
    let time:String
    let temp:String
    let icon:String
    
    init(weatherType:String, date: String, temp: Double, icon: String){
        self.temp = String(temp).appending("c")
        self.time = getTime(date: date)
        self.weatherType = weatherType
        self.icon = String(icon.dropLast())
        self.date = date
    }
}
