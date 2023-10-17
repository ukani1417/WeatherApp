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
    

    func test_AllCity(){
        coreAPI.list = [mockAPI.weather()!]
    
        searchWeatherVM.getAllCity()
        
        XCTAssertEqual(1, searchWeatherVM.searchResults.count)
    }
    
    func test_delete_Success(){
        coreAPI.boolResult = .success(true)
        searchWeatherVM.searchResults.append(mockAPI.weather()!)
        let prev = searchWeatherVM.searchResults.count
        
        if prev != 0 {
            searchWeatherVM.deleteRecord(index: 0)
            
            XCTAssertEqual(searchWeatherVM.searchResults.count, prev-1)
        }
       
        
        
    }
    
    func test_delete_Failure(){
        coreAPI.boolResult = .failure(.internalError)
        searchWeatherVM.searchResults.append(mockAPI.weather()!)
        let prev = searchWeatherVM.searchResults.count
        
        searchWeatherVM.deleteRecord(index: 0)
        
        XCTAssertEqual(prev, searchWeatherVM.searchResults.count)
    }
    
    func test_Update_Success(){
        coreAPI.boolResult = .success(true)
        let data = mockAPI.weather()!
        searchWeatherVM.searchResults.append(data)
        let updateData = CurrentWeatherDTO(weatherType: data.weatherType, city: data.city, temp: "10000.0", humidity: data.humidity, wind: data.wind, icon: data.icon, lat: data.lat, lon: data.lon)
        mockAPI.getCurrentWeatherResult = .success(updateData)
        
        searchWeatherVM.update(index: 0)
        
        XCTAssertTrue(searchWeatherVM.searchResults[0].temp == updateData.temp)
        
        
        
    }
    
    func test_Update_Failure(){
        coreAPI.boolResult = .failure(.internalError)
        let data = mockAPI.weather()!
        searchWeatherVM.searchResults.append(data)
        let updateData = CurrentWeatherDTO(weatherType: data.weatherType, city: data.city, temp: "10000.0", humidity: data.humidity, wind: data.wind, icon: data.icon, lat: data.lat, lon: data.lon)
        
//       Api responce success , core fail
        
        mockAPI.getCurrentWeatherResult = .success(updateData)
        
        searchWeatherVM.update(index: 0)
        
        XCTAssertTrue(searchWeatherVM.searchResults[0].temp == data.temp)
    
//       Api responce failure
                
        mockAPI.getCurrentWeatherResult = .failure(.serverError)
        
        searchWeatherVM.update(index: 0)
        
        XCTAssertTrue(searchWeatherVM.searchResults[0].temp == data.temp)
        
       
    
    }
}
