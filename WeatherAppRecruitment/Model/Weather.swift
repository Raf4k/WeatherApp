//
//  Weather.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import Foundation

// MARK: - WeatherHourly
struct WeatherHourly: Codable {
    let list: [Weather]?
}

// MARK: - Weather
struct Weather: Codable {
    let coord: Coordinate?
    let weather: [WeatherDescription]?
    let main: WeatherInformation?
    let wind: WeatherWind?
    let clouds: WeatherClouds?
    let visibility: Int?
    let dt: Int?
    let dt_txt: String?
    let name: String?
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let lon: Double?
    let lat: Double?
}

// MARK: - WeatherDescription
struct WeatherDescription: Codable {
    let main: String?
    let description: String?
}

// MARK: - WeatherInformation
struct WeatherInformation: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
}

// MARK: - WeatherWind
struct WeatherWind: Codable {
    let speed: Double?
    let deg: Int?
}

// MARK: - WeatherClouds
struct WeatherClouds: Codable {
    let all: Int?
}
