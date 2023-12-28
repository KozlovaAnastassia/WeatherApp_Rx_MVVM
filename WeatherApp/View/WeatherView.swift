//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Анастасия on 23.12.2023.
//

import UIKit
import SnapKit

private extension String {
    static let errorLabel = "Search the app so we can get your current location"
    static let searchBarPlaceholder = "Поиск"
}

private extension CGFloat {
    static let widthInset = 10.0
    static let topContraint = 150.0
    
    static let imageWidth = 120.0
    static let imageHeight = 120.0
    
    static let collectionViewHeight = 100.0
    static let collectionViewItemWight = 60.0
    static let collectionViewItemHeight = 100.0
    
    static let stackViewSpacing = 50.0
}

private extension Int {
    static let errorLabelNumbersOfLines = 0
}


protocol ViewDelegate: AnyObject {
    func getDataForCell(indexPath: IndexPath) -> CellModel
    func getNumbersOfSection() -> Int
    func getDataFromTextField(city: String)
}

final class WeatherView: UIView {
    
    weak var delegate: ViewDelegate?
    private var state: State?
    
    lazy var searchTextField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = String.searchBarPlaceholder
        return searchBar
    }()
    
    private lazy var errorLabel: UILabel = {
       let label = UILabel()
        label.text = String.errorLabel
        label.textAlignment = .center
        label.numberOfLines = Int.errorLabelNumbersOfLines
        label.textColor = .black
        label.isHidden = true
       return label
   }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        return indicator
    }()
    
    
     lazy var cityNameLabel: UILabel = {
        let label =  UILabel()
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = Constants.Fonts.baseFont
        return label
    }()
    
    private lazy var temperaturelabel: UILabel = {
        let label =  UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = Constants.Fonts.headerFont
        return label
    }()
    
    
    private lazy var temperatureImage: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack =  UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = CGFloat.stackViewSpacing
        stack.addArrangedSubview(cityNameLabel)
        stack.addArrangedSubview(temperaturelabel)
        stack.addArrangedSubview(temperatureImage)
        stack.addArrangedSubview(collectionView)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.Errors.initError)
    }
    
        
    private func addSubViews() {
        addSubview(stackView)
        addSubview(errorLabel)
        addSubview(activityIndicator)
    }
        
    private func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(CGFloat.topContraint)
            make.width.equalToSuperview().inset(CGFloat.widthInset)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        temperatureImage.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.imageWidth)
            make.height.equalTo(CGFloat.imageHeight)
        }
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(CGFloat.widthInset)
            make.height.equalTo(CGFloat.collectionViewHeight)
        }
    }
    
    func updateInterfaceWith(currentWeather: CurrentWeather){
        self.cityNameLabel.text = currentWeather.cityName
        self.temperaturelabel.text = currentWeather.temperatureString
        self.temperatureImage.image = UIImage(systemName: currentWeather.systemIconNameString)
    }
    
    func updateErorr(error: String) {
        self.errorLabel.text = error
    }
    
    func failureScreeen() {
        stackView.isHidden = true
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func loadingScreeen() {
        stackView.isHidden = true
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func loadedScreeen() {
        stackView.isHidden = false
        errorLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}


extension WeatherView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.getNumbersOfSection() ?? Int()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.reuseIdentifier,
                                                            for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        
        guard let model  = delegate?.getDataForCell(indexPath: indexPath) else { return cell}
        cell.configure(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: CGFloat.collectionViewItemWight, height: CGFloat.collectionViewItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension WeatherView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text {
            delegate?.getDataFromTextField(city: city)
        }
    }
}
