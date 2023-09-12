//
//  Font+.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit

extension UIFont {
    static func boldFont(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
    
    static func semiboldFont(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func regularFont(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
    
    static func lightFont(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
}
