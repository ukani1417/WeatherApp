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
    
    private var currentWeatherVC: CurrentWeatherVC
    private var searchWeatherVC: SearchWeatherVC
    
    //    MARK: - Init
    
    init(){
        self.currentWeatherVC = CurrentWeatherVC()
        self.searchWeatherVC = SearchWeatherVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setubTabbarController()
        searchWeatherVC.delegate = currentWeatherVC
    }

    //    MARK: - Setub Tabs
    
    private func setubTabbarController(){
        
        setupCurrentWeatherVC()
        setupSearchWeatherVC()
        
        self.viewControllers = [UINavigationController(rootViewController:currentWeatherVC),
                                searchWeatherVC]
        self.tabBar.backgroundColor = ColorConstant.lightBlue
        self.tabBar.tintColor = ColorConstant.frontWhite
        self.tabBar.unselectedItemTintColor = ColorConstant.black
    }
    
    private func setupCurrentWeatherVC(){
        let tabItem = UITabBarItem(title: "MyLocation",
                                   image: UIImage(named: "ic_location_on_48px 2"),
                                   tag: 1)
        currentWeatherVC.tabBarItem = tabItem
        currentWeatherVC.tabBarItem.badgeColor = ColorConstant.frontWhite
    }
    
    private func setupSearchWeatherVC(){
        let tabItem = UITabBarItem(title: "Search",
                                   image: UIImage(named: "search 1"),
                                   tag: 2)
        searchWeatherVC.tabBarItem = tabItem
        
    }
    
    
}

