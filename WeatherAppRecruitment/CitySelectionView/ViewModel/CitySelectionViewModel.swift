//
//  CitySelectionViewModel.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit

class CitySelectionViewModel: NSObject {
    var savedCities = [Cities]()
    
    func reloadData() {
        savedCities = CityWeatherStorage.shared.allSavedCities()
    }
}
