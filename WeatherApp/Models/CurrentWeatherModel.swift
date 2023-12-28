//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Анастасия on 23.12.2023.
//

import Foundation

struct CurrentWeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let id: Int
}
