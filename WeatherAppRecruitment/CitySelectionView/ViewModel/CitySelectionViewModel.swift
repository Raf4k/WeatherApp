//
//  CitySelectionViewModel.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit

// MARK: - CitySelectionViewModel
final class CitySelectionViewModel: NSObject {
    var savedCities = [Cities]()
    
    func reloadData() {
        savedCities = CityWeatherStorage.shared.allSavedCities()
    }
    
    func loadDetailsData(from city: SelectedCity?, completion: @escaping (Result<Weather, Error>) -> Void) {
        guard let lat = city?.lat, let long = city?.long else {
            completion(.failure(WeatherDataError.invalidInput))
            return
        }
        let params: [String: Any] = [
            "lat": lat,
            "lon": long,
            "units": "metric"
        ]
        
        ApiManager.shared.getData(path: ApiDefines.API_WEATHER, params: params) { result in
            completion(result)
        }
    }
}
