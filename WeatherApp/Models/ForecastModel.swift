//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Анастасия on 21.12.2023.
//

import Foundation

struct ForecastModel: Codable {
    let list: [List]
}

struct List: Codable {
    let dt_txt: String
    let main: Temp
}

struct Temp: Codable {
    let temp: Double
}


