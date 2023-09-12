//
//  UIView+.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
