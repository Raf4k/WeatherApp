//
//  String+.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

extension String {
    var localized: String {
        var result = Bundle.main.localizedString(forKey: self, value: nil, table: nil)
        
        return result
    }
}
