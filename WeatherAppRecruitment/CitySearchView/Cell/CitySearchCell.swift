//
//  CitySelectionCell.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit
import MapKit

class CitySearchCell: UITableViewCell {
    
    lazy var minatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.circle.fill")
        imageView.tintColor = .red
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldFont(size: 15)
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .lightFont(size: 13)
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
        addSubviews([
            titleLabel,
            subtitleLabel,
            minatureImageView
        ])
        
        minatureImageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(12)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(minatureImageView.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailing).offset(-12)
            make.top.equalTo(snp.top).offset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
    }

    func customize(_ item: SearchedCities) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        minatureImageView.image = UIImage(systemName: "magnifyingglass")
    }
    
    func customize(_ item: MKLocalSearchCompletion) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        minatureImageView.image = UIImage(systemName: "mappin.circle.fill")
    }
}
