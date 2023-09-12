//
//  CityDetailsHeader.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

// MARK: CityDetailsHeader
final class CityDetailsHeader: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .regularFont(size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading).offset(16)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    func configure(section: CityDetailsSectionType?) {
        titleLabel.text = section?.headerTitle
    }
}

