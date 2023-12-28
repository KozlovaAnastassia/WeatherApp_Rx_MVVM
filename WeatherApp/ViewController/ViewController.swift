//
//  ViewController.swift
//  WeatherApp
//
//  Created by Анастасия on 20.12.2023.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift

final class ViewController: UIViewController, ViewDelegate {
    
    private var state: State = .plain {
        didSet {
            switch state  {
            case .failure: weatherView.failureScreeen()
            case .loading: weatherView.loadingScreeen()
            case .loaded:  weatherView.loadedScreeen()
            default:  weatherView.loadingScreeen()
            }
        }
    }

    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        return lm
    }()
    
    private let weatherView = WeatherView()
    private var viewModel: IWeatherViewModel
    private let disposedBag = DisposeBag()
    
    init(viewModel: IWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError(Constants.Errors.initError)
    }
    override func loadView() {
        super.loadView()
        view = weatherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = weatherView.searchTextField
        
        state = .loading
        weatherView.delegate = self
        updateInterface()
        locationManager.requestLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
     }
    
    func getDataForCell(indexPath: IndexPath) -> CellModel {
        viewModel.getDataForCell(indexPath: indexPath)
    }
    
    func getNumbersOfSection() -> Int {
        viewModel.numberOfRowsInSection
    }
    func getDataFromTextField(city: String) {
        state = .loading
        viewModel.getDataFromTextField(city: city)
    }
    
     func updateInterface() {
         viewModel.error.subscribe { event in
             guard let eventEl = event.element else {return}
             self.weatherView.updateErorr(error: eventEl)
             self.state = .failure
         }.disposed(by: disposedBag)
         
        viewModel.currentWeatherData.subscribe{ event in
            self.state = .loaded
            guard let eventEl = event.element else {return}
            self.weatherView.updateInterfaceWith(currentWeather: eventEl)
        }.disposed(by: disposedBag)
    
        viewModel.forecastWeatherData.subscribe{ event in
            self.state = .loaded
            self.weatherView.reloadCollectionView()
        }.disposed(by: disposedBag)
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        viewModel.locationMagare(latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        state = .failure
    }
    
}
