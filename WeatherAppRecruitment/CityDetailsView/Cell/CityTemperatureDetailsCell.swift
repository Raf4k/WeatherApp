//
//  CityTemperatureDetailsCell.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

// MARK: CityTemperatureDetailsCell
final class CityTemperatureDetailsCell: UICollectionViewCell {
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .regularFont(size: 12)
        label.numberOfLines = 2
        return label
    }()
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .regularFont(size: 12)
        label.numberOfLines = 1
        return label
    }()
    private var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud.fill")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(.allCorners, radius: 10.0)
    }
    
    func setupView() {
        backgroundColor = .white
        addSubviews([
            dateLabel,
            temperatureLabel,
            weatherImage
        ])
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(8)
            make.trailing.equalTo(snp.trailing).offset(-8)
            make.top.equalTo(snp.top).offset(12)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(8)
            make.trailing.equalTo(snp.trailing).offset(-8)
            make.bottom.equalTo(snp.bottom).offset(-12)
        }
    }
    
    func customize(weather: Weather) {
        dateLabel.text = weather.dt_txt
        if let temp = weather.main?.temp {
            temperatureLabel.text = "\(Int(temp))°C"
        }
    }
}
