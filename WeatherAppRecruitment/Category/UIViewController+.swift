//
//  UIViewController+.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit

// MARK: UIViewController
extension UIViewController {
    func presentErrorAlert() {
        let alert = UIAlertController(title: "alert.title".localized, message: "alert.message".localized, preferredStyle: .alert)
        present(alert, animated: true)
    }
}
