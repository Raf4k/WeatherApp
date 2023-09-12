//
//  CityDetailsView.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit
import WeatherKit
import CoreLocation

class CityDetailsView: UIViewController {

    let weatherService = WeatherService()
    
    var selectedCity: SelectedCity?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
