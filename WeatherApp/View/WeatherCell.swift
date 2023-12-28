//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Анастасия on 23.12.2023.
//

import UIKit

private extension CGFloat {
    static let stackViewSpacing = 20.0
}

final class WeatherCell: UICollectionViewCell {
    static var reuseIdentifier: String {"\(Self.self)"}

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Constants.Fonts.collectionViewFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Constants.Fonts.collectionViewFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = CGFloat.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(tempLabel)
       
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .blue
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError(Constants.Errors.initError)
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    func configure(model: CellModel) {
        tempLabel.text = String(model.temp)
        dateLabel.text = model.date
    }
}
