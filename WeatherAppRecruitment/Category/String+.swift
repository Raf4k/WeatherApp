//
//  String+.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

// MARK: String
extension String {
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
}
