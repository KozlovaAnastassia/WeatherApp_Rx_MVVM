//
//  WeatherM.swift
//  WeatherApp
//
//  Created by Анастасия on 23.12.2023.
//

import Foundation

private extension String {
    static let temperatureFormat = "%.0f C"
   
    static let cloudBoltRainPict = "cloud.bolt.rain.fill"
    static let cloudDrizzlePict = "cloud.drizzle.fill"
    static let cloudRainPict = "cloud.bolt.rain.fill"
    static let cloudSnowPict = "cloud.snow.fill"
    static let smokePict = "smoke.fill"
    static let cloudPict = "cloud.fill"
    static let sunPict = "sun.min.fill"
    static let defaultPict = "nosign"
}

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: String.temperatureFormat, temperature)
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return String.cloudBoltRainPict
        case 300...321: return String.cloudDrizzlePict
        case 500...531: return String.cloudRainPict
        case 600...622: return String.cloudSnowPict
        case 701...781: return String.smokePict
        case 800: return String.sunPict
        case 801...804: return String.cloudPict
        default: return String.defaultPict
        }
    }
    
    init?(currentWeatherData: CurrentWeatherModel) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        conditionCode = currentWeatherData.weather.first!.id
    }
}
