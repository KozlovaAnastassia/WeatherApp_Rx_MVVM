//
//  Model.swift
//  WeatherApp
//
//  Created by Анастасия on 21.12.2023.
//

import Foundation

private extension String {
    static let temperatureFormat = "%.0f C"
    static let temperatureTime = "15:00:00"
    static let dateSeparator = "-"
    static let dateTimeSeparator = " "
    static let monthDaySeparator = "."
}

private extension Double {
    static let kelvinConstant = 273.15
}


struct ForecastWeather {
    private var forecast = [List]()
    
    var dataDict: [CellModel] {
        var dict = [CellModel]()
        for i in forecast {
            
            let dateString = i.dt_txt
            let dataOnly = dateString.components(separatedBy: String.dateTimeSeparator)
            if dataOnly[1] == String.temperatureTime {
                dict.append(CellModel(date: makeDataShort(dataOnly[0]),
                                      temp: makeTempToCelsius(i.main.temp)))
            }
        }
        return dict
    }
    
    init?(weatheDays: ForecastModel) {
        forecast = weatheDays.list
    }
    
    private func makeTempToCelsius(_ tempurature: Double) -> String {
        let temperatureCelsius = tempurature - Double.kelvinConstant
        return String(format: String.temperatureFormat, temperatureCelsius)
    }
    private func makeDataShort(_ date: String) -> String {
        let dateComponets = date.components(separatedBy: String.dateSeparator)
        let newDateString = "\(dateComponets[2])\(String.monthDaySeparator)\(dateComponets[1])"
        return newDateString
    }
}
