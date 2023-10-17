//
//  CDWeatherRepository.swift
//  Weather
//
//  Created by Dhruv Ukani on 14/10/23.
//

import Foundation
import CoreData

enum CoreRepoError: String , Error {
    case cityNotFound = "City not Found"
    case internalError = "Internal Error,Try again after some time"
}
protocol CoreRepo {
    func get(city: String)->Result<CurrentWeatherDTO,CoreRepoError>
    func getList()->Result<[CurrentWeatherDTO],Never>
    func create(currentWeatherDTO: CurrentWeatherDTO)->Result<Bool,CoreRepoError>
    func update(currentWeatherDTO:CurrentWeatherDTO)->Result<Bool,CoreRepoError>
    func delete(city:String)->Result<Bool,CoreRepoError>
}

class CDWeatherRepository : CoreRepo {
    var managedObjectContext : NSManagedObjectContext = PersistentStorage.shared.context
    
    func get(city: String)->Result<CurrentWeatherDTO,CoreRepoError>{
        guard  let getCity = getCity(city: city) else {
            return .failure(.cityNotFound)
        }
        let currentWeatherDTO = getCity.toConvert()
        return .success(currentWeatherDTO)
    }
    
    func getList()->Result<[CurrentWeatherDTO],Never>{
        let cityList = PersistentStorage.shared.fetchManagedObject(managedObject: CDCurrentWeatherDTO.self)
        var convertedCityList = [CurrentWeatherDTO]()
        cityList?.forEach({ obj in
            convertedCityList.append(obj.toConvert())
        })
        return .success(convertedCityList)
    }
    
    func create(currentWeatherDTO: CurrentWeatherDTO)->Result<Bool,CoreRepoError>{
        let newCity = CDCurrentWeatherDTO(context: managedObjectContext)
        newCity.city = currentWeatherDTO.city
        newCity.date = currentWeatherDTO.date
        newCity.humidity = currentWeatherDTO.humidity
        newCity.temp = currentWeatherDTO.temp
        newCity.weatherType = currentWeatherDTO.weatherType
        newCity.wind = currentWeatherDTO.wind
        newCity.lat = currentWeatherDTO.lat
        newCity.lon = currentWeatherDTO.lon
        newCity.icon = currentWeatherDTO.icon
        do{
            try self.managedObjectContext.save()
            return .success(true)
        }
        catch let error{
           debugPrint( "save operation : \(error.localizedDescription)")
            return .failure(.internalError)
        }
        
    }

    func delete(city:String)->Result<Bool,CoreRepoError>{
        guard let getCity = getCity(city: city) else{
            return .failure(.cityNotFound)
        }
        managedObjectContext.delete(getCity)
        do{
            try self.managedObjectContext.save()
            return .success(true)
        }
        catch{
            debugPrint("delete operation : \(error.localizedDescription)")
            return (.failure(.internalError))
        }
    }
    
    func update(currentWeatherDTO:CurrentWeatherDTO)->Result<Bool,CoreRepoError>{
        guard let getCity = getCity(city: currentWeatherDTO.city) else{
            return .failure(CoreRepoError.cityNotFound)
        }
        getCity.city = currentWeatherDTO.city
        getCity.date = currentWeatherDTO.date
        getCity.humidity = currentWeatherDTO.humidity
        getCity.temp = currentWeatherDTO.temp
        getCity.weatherType = currentWeatherDTO.weatherType
        getCity.wind = currentWeatherDTO.wind
        getCity.lat = currentWeatherDTO.lat
        getCity.lon = currentWeatherDTO.lon
        getCity.icon = currentWeatherDTO.icon
        do{
            try self.managedObjectContext.save()
            return .success(true)
        }
        catch{
            debugPrint("update operation : \(error.localizedDescription)")
            return .failure(.internalError)
        }
    }
    
    private func getCity(city: String)->CDCurrentWeatherDTO?{
        let fetchRequest = NSFetchRequest<CDCurrentWeatherDTO>(entityName:"CDCurrentWeatherDTO")
        let predicate = NSPredicate(format: "city == %@", city)
        fetchRequest.predicate = predicate
        do {
            let cdCurrentWeather = try managedObjectContext.fetch(fetchRequest).first
            guard cdCurrentWeather != nil else {
                debugPrint("Operation : GET CDCuuentWeather | City Not Found With name : \(city)")
                return nil
            }
            return cdCurrentWeather
        }
        catch {
            debugPrint("get operation : \(error.localizedDescription)")
            return nil
        }
    }
}
