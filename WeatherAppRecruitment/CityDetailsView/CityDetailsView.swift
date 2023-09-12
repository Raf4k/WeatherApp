//
//  CityDetailsView.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import UIKit
import CoreLocation

// MARK: CityInfoDetailsCell
enum CityDetailsSectionType: Int {
    case weatherInfo
    case weatherHourly
    
    var headerTitle: String? {
        switch self {
        case .weatherInfo:
            return nil
        case .weatherHourly:
            return "details.hourly.header".localized
        }
    }
    
    static let allValues = [weatherInfo, weatherHourly]
}

// MARK: - CityDetailsView
final class CityDetailsView: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = CityDetailsCompositionalLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout.createCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(cellWithClass: CityInfoDetailsCell.self)
        collectionView.register(cellWithClass: CityTemperatureDetailsCell.self)
        collectionView.register(
            supplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withClass: CityDetailsHeader.self)
        return collectionView
    }()
    private lazy var addCityToListBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(addOrRemoveCityFromList))
        return button
    }()
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var viewModel = CityDetailsViewModel()
    private var weatherList = [Weather]()
    
    var actualWeatherData: Weather?
    var selectedCity: SelectedCity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = addCityToListBarButton
        setupView()
        prepareBarButton()
        activityIndicatorView.startAnimating()
        viewModel.getWeatherData(from: actualWeatherData) { result in
            self.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let weatherData):
                self.weatherList = weatherData.list ?? []
                self.collectionView.reloadData()
            case .failure(_):
                self.presentErrorAlert()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .backgroundColor
        view.addSubviews([
            collectionView,
            activityIndicatorView
        ])
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func prepareBarButton() {
        if CityWeatherStorage.shared.cityWasSaved(selectedCity?.title ?? "") {
            addCityToListBarButton.image = UIImage(systemName: "heart.fill")
        } else {
            addCityToListBarButton.image = UIImage(systemName: "heart")
        }
    }
    
    @objc
    func addOrRemoveCityFromList() {
        viewModel.removeOrAddSelectedCity(selectedCity: selectedCity)
        prepareBarButton()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CityDetailsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CityDetailsSectionType.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CityDetailsSectionType(rawValue: section)
        switch sectionType {
        case .weatherInfo:
            return 1
        default:
            return weatherList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = CityDetailsSectionType(rawValue: indexPath.section)
        
        switch sectionType {
        case .weatherInfo:
            let cell = collectionView.dequeueReusableCell(
                withClass: CityInfoDetailsCell.self,
                for: indexPath)
            cell.customize(name: selectedCity?.title, info: actualWeatherData)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withClass: CityTemperatureDetailsCell.self,
                for: indexPath)
            cell.customize(weather: weatherList[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withClass: CityDetailsHeader.self,
                for: indexPath)
            header.configure(section: CityDetailsSectionType(rawValue: indexPath.section))
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
