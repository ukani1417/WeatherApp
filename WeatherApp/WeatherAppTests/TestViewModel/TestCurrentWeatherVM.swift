//
//  TestCurrentWeatherVM.swift
//  WeatherAppTests
//
//  Created by Dhruv Ukani on 17/10/23.
//

import XCTest
@testable import WeatherApp
final class TestCurrentWeatherVM: XCTestCase {

    private var currentWeatherVM: CurrentWeatherVM!
    private var mockApi: MockWeatherAPI!
    
        
    override func setUp()  {
        super.setUp()
        mockApi = MockWeatherAPI()
        currentWeatherVM = CurrentWeatherVM(_repository: mockApi)
    }

    override func tearDown()  {
        mockApi = nil
        currentWeatherVM = nil
        super.tearDown()
    }

    func test_CurrVM_With_Success(){
        let input = CurrentWeatherDTO(weatherType: "Cloud", city: "Palitana", temp: "30.33", humidity: "59", wind: "120", icon: "01d", lat: "21.00", lon: "22.00")
        mockApi.getCurrentWeatherResult = .success(input)
        
        currentWeatherVM.getCurrentWeather(location: LocationModel(lat: "21.00", lon: "22.00"))
        
        XCTAssertNotNil(currentWeatherVM.currentWeatherDTO)
        XCTAssertEqual(input.lat, currentWeatherVM.currentWeatherDTO?.lat)
        
    }

    func test_CurrVM_With_Failure(){
        mockApi.getCurrentWeatherResult = .failure(.serverError)
        
        currentWeatherVM.getCurrentWeather(location: LocationModel(lat: "", lon: ""))
        
        XCTAssertNil(currentWeatherVM.currentWeatherDTO)
        
    }

}
