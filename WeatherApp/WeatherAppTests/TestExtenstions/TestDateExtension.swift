//
//  TestDateExtension.swift
//  WeatherAppTests
//
//  Created by Dhruv Ukani on 17/10/23.
//

import XCTest
import Foundation
@testable import WeatherApp
final class TestDateExtension: XCTestCase {

    func test_ToWeek(){
        let dateformater = DateFormatter()
        dateformater.dateFormat = "EEEE"
        let ans = dateformater.string(from: Date())
        XCTAssertEqual(Date().toWeekDay(), ans)
    }
    
    func test_ToMedium(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM d, yyyy"
        
        let ans = dateFormater.string(from: Date())
        
        XCTAssertEqual(Date().toMediumStyle(), ans)
    }
    
    
}
