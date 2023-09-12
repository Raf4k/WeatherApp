//
//  CitySelectionCell.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit

class CitySelectionCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldFont(size: 18)
        label.numberOfLines = 1
        return label
    }()
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularFont(size: 12)
        label.numberOfLines = 1
        return label
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularFont(size: 12)
        label.numberOfLines = 1
        label.text = "Głownie chmury"
        return label
    }()
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "26°"
        label.textColor = .black
        label.font = .boldFont(size: 24)
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubviews([
            cityLabel,
            countryLabel,
            descriptionLabel,
            temperatureLabel
        ])
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(8)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(cityLabel.snp.bottom).offset(48)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
        }
    }
    
    func customize(_ city: Cities) {
        cityLabel.text = city.name
        countryLabel.text = city.country
    }
}
