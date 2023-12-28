//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Анастасия on 23.12.2023.
//

import UIKit
import RxCocoa
import RxSwift

protocol IWeatherViewModel {
    var numberOfRowsInSection: Int {get}
    
    func getDataForCell(indexPath: IndexPath) -> CellModel
    func getDataFromTextField(city: String)
    func locationMagare(latitude: Double, longitude: Double)
    
    var currentWeatherData: PublishRelay<CurrentWeather>  {get set}
    var forecastWeatherData: PublishRelay<ForecastWeather>  {get set}
    var error: PublishRelay<String> {get set}

}

final class WeatherViewModel: IWeatherViewModel  {
    
    var mainDict = [CellModel]()
    var networkWeatherManager: INetworkWeatherManager
    var numberOfRowsInSection: Int {return self.mainDict.count}
    
    var currentWeatherData = PublishRelay<CurrentWeather>()
    var forecastWeatherData = PublishRelay<ForecastWeather>()
    var error = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    
    init(networkWeatherManager: INetworkWeatherManager) {
        self.networkWeatherManager = networkWeatherManager
        
        networkWeatherManager.currentWeather.subscribe { event in
            self.currentWeatherData.accept(event)
        }.disposed(by: disposeBag)
        
        networkWeatherManager.forecastWeather.subscribe { event in
            guard let eventData = event.element else { return}
            self.mainDict = eventData.dataDict
            self.forecastWeatherData.accept(eventData)
        }.disposed(by: disposeBag)
        
        networkWeatherManager.errorHandler.subscribe{ event in
                guard let eventData = event.element else { return}
                self.error.accept(eventData)
        }.disposed(by: self.disposeBag)
            
    }
    
    func getDataForCell(indexPath: IndexPath) -> CellModel {
        mainDict[indexPath.row]
    }
    
    
    func getDataFromTextField(city: String) {
        self.networkWeatherManager.fetchWeather(forRequestType: .searchLocation(city: city))
    }
    
    func locationMagare(latitude: Double, longitude: Double) {
        networkWeatherManager.fetchWeather(forRequestType: .currentLocation(latitude: latitude, longitude: longitude))
    }
}

