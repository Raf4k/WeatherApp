//
//  CityDetailsViewModel.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit
import Alamofire

// MARK: - CityDetailsViewModel
final class CityDetailsViewModel: NSObject {
    func getWeatherData(from city: Weather?, completion: @escaping (Result<WeatherHourly, Error>) -> Void) {
        guard let lat = city?.coord?.lat, let long = city?.coord?.lon else {
            completion(.failure(WeatherDataError.invalidInput))
            return
        }
        let params: [String: Any] = [
            "lat": lat,
            "lon": long,
            "units": "metric"
        ]
        
        ApiManager.shared.getData(path: ApiDefines.API_HOURLY, params: params) { (result: Result<WeatherHourly, Error>) in
            completion(result)
        }
    }
    
    func removeOrAddSelectedCity(selectedCity: SelectedCity?) {
        if CityWeatherStorage.shared.cityWasSaved(selectedCity?.title ?? "") {
            CityWeatherStorage.shared.removeSavedCity(savedCity: selectedCity)
        } else {
            guard let name = selectedCity?.title,
                    let country = selectedCity?.subtitle,
                    let lat = selectedCity?.lat,
                    let long = selectedCity?.long else { return }
            CityWeatherStorage.shared.saveNewCity(name: name, country: country, lat: lat, long: long)
        }
    }
}
