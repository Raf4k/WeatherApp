//
//  CityInfoDetailsCell.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

// MARK: - WeatherTemperatureType
enum WeatherTemperatureType {
    case cold
    case regular
    case hot
    
    var color: UIColor {
        switch self {
        case .cold:
            return .blue
        case .regular:
            return .black
        case .hot:
            return .red
        }
    }
}

// MARK: CityInfoDetailsCell
final class CityInfoDetailsCell: UICollectionViewCell {
    private var cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldFont(size: 32)
        label.numberOfLines = 0
        return label
    }()
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldFont(size: 45)
        label.numberOfLines = 1
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .lightFont(size: 16)
        label.numberOfLines = 2
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularFont(size: 16)
        label.numberOfLines = 2
        return label
    }()
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .backgroundColor
        addSubviews([
            cityNameLabel,
            temperatureLabel,
            descriptionLabel,
            dateLabel
        ])
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(snp.top).offset(32)
            make.leading.equalTo(snp.leading).offset(8)
            make.trailing.equalTo(snp.trailing).offset(-8)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityNameLabel.snp.bottom).offset(8)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
    }
    
    func customize(name: String?, info: Weather?) {
        cityNameLabel.text = name
        dateLabel.text = Self.dateFormatter.string(from: Date())
        guard let temp = info?.main?.temp,
              let minTemp = info?.main?.temp_min,
              let maxTemp = info?.main?.temp_max else { return }
        
        temperatureLabel.text = "\(Int(temp))°C"
        temperatureLabel.textColor = weatherTemperatureType(temp: temp).color
        descriptionLabel.text = String(format: "details.temperature.from.to".localized,
                                       Int(minTemp),
                                       Int(maxTemp))
    }
    
    private func weatherTemperatureType(temp: Double) -> WeatherTemperatureType {
        if temp < 10 {
            return .cold
        } else if temp < 20 {
            return .regular
        } else {
            return .hot
        }
    }
}
