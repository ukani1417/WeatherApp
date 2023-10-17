//
//  MockCoreWeatherAPI.swift
//  WeatherAppTests
//
//  Created by Dhruv Ukani on 17/10/23.
//

import Foundation
@testable import WeatherApp

class MockCoreWeatherAPI: CoreRepo {
    
    var currentWeatherDTO: CurrentWeatherDTO!
    var city: String!
    var list: [CurrentWeatherDTO]!
    var result: Result<CurrentWeatherDTO,CoreRepoError>!
    var boolResult: Result<Bool,CoreRepoError>!
    
    func get(city: String) -> Result<WeatherApp.CurrentWeatherDTO, WeatherApp.CoreRepoError> {
        return result
    }
    
    func getList() -> Result<[WeatherApp.CurrentWeatherDTO], Never> {
        return .success(list)
    }
    
    func create(currentWeatherDTO: WeatherApp.CurrentWeatherDTO) -> Result<Bool, WeatherApp.CoreRepoError> {
        return boolResult
    }
    
    func update(currentWeatherDTO: WeatherApp.CurrentWeatherDTO) -> Result<Bool, WeatherApp.CoreRepoError> {
        return boolResult
    }
    
    func delete(city: String) -> Result<Bool, WeatherApp.CoreRepoError> {
        return boolResult
    }
    
    
}
