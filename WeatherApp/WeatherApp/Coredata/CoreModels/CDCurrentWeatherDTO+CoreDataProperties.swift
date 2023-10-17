//
//  CDCurrentWeatherDTO+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Dhruv Ukani on 16/10/23.
//
//

import Foundation
import CoreData


extension CDCurrentWeatherDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrentWeatherDTO> {
        return NSFetchRequest<CDCurrentWeatherDTO>(entityName: "CDCurrentWeatherDTO")
    }

    @NSManaged public var city: String?
    @NSManaged public var temp: String?
    @NSManaged public var wind: String?
    @NSManaged public var humidity: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherType: String?
    @NSManaged public var date: String?

}

extension CDCurrentWeatherDTO : Identifiable {
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
