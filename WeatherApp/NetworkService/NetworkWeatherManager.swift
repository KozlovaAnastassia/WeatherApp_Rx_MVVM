//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Анастасия on 21.12.2023.
//

import CoreLocation
import RxSwift
import RxCocoa


private enum UrlString {

    case coordinatesURL(city: String)
    case forecastWeatherURL(latitude: Double, longitude: Double)
    case currentWeatherURL(latitude: Double, longitude: Double)

    var rawValue: String {
        switch self {
        case .coordinatesURL(let city):
            return "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=\(Constants.Api.key)"
        case .forecastWeatherURL(let latitude, let longitude):
            return  "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.Api.key)"
        case .currentWeatherURL(let latitude, let longitude):
            return  "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(Constants.Api.key)&units=metric"
        }
    }
}

protocol INetworkWeatherManager {
    var currentWeather: PublishRelay<CurrentWeather> {get set}
    var forecastWeather: PublishRelay<ForecastWeather>{get set}
    var errorHandler: PublishRelay<String> {get set}
    
    func fetchWeather(forRequestType requestType: RequestType)
}

final class NetworkWeatherManager: INetworkWeatherManager {
    
    var currentWeather = PublishRelay<CurrentWeather>()
    var forecastWeather = PublishRelay<ForecastWeather>()
    var errorHandler = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    func fetchWeather(forRequestType requestType: RequestType) {
        switch requestType {
        case .searchLocation(let city):
            if let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                coordinatesResult(encodedCity: encodedCity)
            }
        case .currentLocation(let latitude, let longitude):
            forecastWeatherResult(latitude: latitude, longitude: longitude)
            currentWeatherResult(latitude: latitude, longitude: longitude)
        }
    }
    
    private func coordinatesResult(encodedCity: String) {
        let urlString = UrlString.coordinatesURL(city: encodedCity).rawValue
        
        request(urlString: urlString, successHandler: { [weak self] (response: [LocationModel]) in
            if response.isEmpty == false {
                let data = response[0]
                self?.forecastWeatherResult(latitude: data.lat, longitude: data.lon)
                self?.currentWeatherResult(latitude: data.lat, longitude: data.lon)
            }
            else {
                self?.errorHandler.accept(Constants.Errors.noExistCity)
            }
        }, failureHandler: { error in
                self.errorHandler.accept(error.localizedDescription)
        })
    }
    
    private func forecastWeatherResult(latitude: Double, longitude: Double) {
        let urlString = UrlString.forecastWeatherURL(latitude: latitude, longitude: longitude).rawValue
    
        request(urlString: urlString, successHandler: { [weak self] (response: ForecastModel) in
                        if let weatherForecast = ForecastWeather(weatheDays: response) {
                            self?.forecastWeather.accept(weatherForecast)
                            }
                }, failureHandler: { error in
                    self.errorHandler.accept(error.localizedDescription)
        })
    }
    
    private func currentWeatherResult(latitude: Double, longitude: Double) {
        let urlString = UrlString.currentWeatherURL(latitude: latitude, longitude: longitude).rawValue
        
        request(urlString: urlString, successHandler: { [weak self] (response: CurrentWeatherModel) in
                    if let currentWeather = CurrentWeather(currentWeatherData: response) {
                        self?.currentWeather.accept(currentWeather)
                    }
                }, failureHandler: { error in
                    self.errorHandler.accept(error.localizedDescription)
        })
    }
    
    private func request<T: Codable>(urlString: String, successHandler: @escaping (T) -> Void, failureHandler: @escaping (Error) -> Void ) {
           guard let url = URL(string: urlString) else {return}
           
           URLSession.shared.rx.data(request: URLRequest(url: url))
               .observeOn(MainScheduler.instance)
               .subscribe(onNext: { data in
                   do {
                       let decodedData = try JSONDecoder().decode(T.self, from: data)
                       successHandler(decodedData)
                   } catch {
                       failureHandler(error)
                   }
               }, onError: { error in
                   failureHandler(error)
               }).disposed(by: disposeBag)
        }
}


