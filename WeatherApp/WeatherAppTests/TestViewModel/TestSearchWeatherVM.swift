//
//  TestSearchWeatherVM.swift
//  WeatherAppTests
//
//  Created by Dhruv Ukani on 17/10/23.
//

import XCTest
@testable import WeatherApp
final class TestSearchWeatherVM: XCTestCase {

    private var searchWeatherVM: SearchWeatherVM!
    private var mockAPI: MockWeatherAPI!
    private var coreAPI: MockCoreWeatherAPI!
    private var cityLocation: LocationModel!
    
    override func setUp() {
       super.setUp()
       mockAPI = MockWeatherAPI()
       coreAPI = MockCoreWeatherAPI()
       searchWeatherVM = SearchWeatherVM(_repository: mockAPI, _coreReporitory: coreAPI)
       cityLocation = LocationModel(lat: "21.22", lon: "-30.22")
    }

    override func tearDown() {
        mockAPI = nil
        coreAPI = nil
        searchWeatherVM = nil
        cityLocation = nil
       super.tearDown()
    }
    
    func test_SearchVM_With_City_Failure(){
        mockAPI.cityLocationResult = .failure(.cityNotFound)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.getCityLocation(city: "Palitana")
        
        XCTAssertTrue(prev == searchWeatherVM.searchResults.count)
    }
    
    func test_SearchVM_With_City_Success_Weather_Failure(){
        mockAPI.cityLocationResult = .success(cityLocation)
        mockAPI.getCurrentWeatherResult = .failure(.serverError)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.getCityLocation(city: "Palitana")
        
        XCTAssertTrue(prev == searchWeatherVM.searchResults.count)
    }
    
    func test_SearchVM_With_City_Success_Weather_Success_Core_Failure(){
        mockAPI.cityLocationResult = .success(cityLocation)
        mockAPI.getCurrentWeatherResult = .success(mockAPI.weather()!)
        coreAPI.boolResult = .failure(.internalError)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.getCityLocation(city: "Palitana")
        
        XCTAssertTrue(prev == searchWeatherVM.searchResults.count)
    }
    
    func test_SearchVM_With_City_Success_Weather_Success_Core_Success(){
        mockAPI.cityLocationResult = .success(cityLocation)
        mockAPI.getCurrentWeatherResult = .success(mockAPI.weather()!)
        coreAPI.boolResult = .success(true)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.getCityLocation(city: "Palitana")
        
        XCTAssertTrue(prev == (searchWeatherVM.searchResults.count - 1))
    }
    
    func test_SearchVM_With_City_Exist_Update_Record(){
        mockAPI.cityLocationResult = .success(LocationModel(lat: "10.99", lon: "44.34"))
        mockAPI.getCurrentWeatherResult = .success(mockAPI.weather()!)
        coreAPI.boolResult = .success(true)
        searchWeatherVM.searchResults.append(mockAPI.weather()!)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.getCityLocation(city: "Zocca")
        
        XCTAssertTrue(prev == searchWeatherVM.searchResults.count)
    }
    
    func test_SearchVM_With_City_Success_Weather_Success_Core_Failure_InUpdate(){
        mockAPI.cityLocationResult = .success(cityLocation)
        
        let oldDTO = mockAPI.weather()!
        let newDTO = CurrentWeatherDTO(weatherType: "Rainy", city: oldDTO.city, temp: oldDTO.temp, humidity: oldDTO.humidity, wind: oldDTO.wind, icon: oldDTO.icon, lat: oldDTO.lat, lon: oldDTO.lon)
        
        mockAPI.getCurrentWeatherResult = .success(oldDTO)
        coreAPI.boolResult = .failure(.internalError)
        searchWeatherVM.searchResults.append(oldDTO)
        
        
        searchWeatherVM.getCityLocation(city: "Zocca")
        
        XCTAssertFalse(searchWeatherVM.searchResults.first?.weatherType == newDTO.weatherType)
    }

    func test_AllCity(){
        coreAPI.list = [mockAPI.weather()!]
    
        searchWeatherVM.getAllCity()
        
        XCTAssertEqual(1, searchWeatherVM.searchResults.count)
    }
}
