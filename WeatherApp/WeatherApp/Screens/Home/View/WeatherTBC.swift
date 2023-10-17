//
//  WeatherTBC.swift
//  Weather
//
//  Created by Dhruv Ukani on 08/10/23.
//

import UIKit
import CoreLocation


class WeatherTBC: UITabBarController ,UITabBarControllerDelegate {
    //    MARK: - Intializers
   
    private var currentWeatherController : CurrentWeatherVC
    private var searchWeatherController : SearchWeatherVC
    
    //    MARK: - Init
    
    init(){
        self.currentWeatherController = CurrentWeatherVC()
        self.searchWeatherController = SearchWeatherVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        setupTabs()
    }
    
    //    MARK: - Setub Tabs
    
    private func setupTabs(){
       
        let firstTabItem = UITabBarItem(title: "MyLocation",
                                        image: UIImage(named: "ic_location_on_48px 2"),
                                        tag: 1)
        currentWeatherController.tabBarItem = firstTabItem
        currentWeatherController.tabBarItem.badgeColor = ColorConstant.frontWhite
        
        let secondTabItem = UITabBarItem(title: "Search",
                                         image: UIImage(named: "search 1"),
                                         tag: 2)
        
        searchWeatherController.tabBarItem = secondTabItem
        searchWeatherController.delegate = currentWeatherController
        
        self.viewControllers = [UINavigationController(rootViewController:currentWeatherController),
                                searchWeatherController]
        self.tabBar.backgroundColor = ColorConstant.lightBlue
        self.tabBar.tintColor = ColorConstant.frontWhite
        self.tabBar.unselectedItemTintColor = ColorConstant.black
    }
}

