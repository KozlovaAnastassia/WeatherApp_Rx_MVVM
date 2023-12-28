//
//  Constants.swift
//  WeatherApp
//
//  Created by Анастасия on 21.12.2023.
//

import UIKit
import CoreLocation

enum State {
    case plain
    case failure
    case loaded
    case loading
}

enum RequestType {
    case searchLocation(city: String)
    case currentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

enum Constants {
    enum Errors {
        static let initError  = "init(coder:) has not been implemented"
        static let networkError  = "No data for this request"
        static let noExistCity = "Such a city does not exist"
    }
    
    enum Fonts {
        static let headerFont = UIFont.systemFont(ofSize: 50, weight: .medium)
        static let baseFont = UIFont.systemFont(ofSize: 25)
        static let collectionViewFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    enum Api {
        static let key = "50e39fa690a5dc05ceb05e04bd6b033c"
    }
}
