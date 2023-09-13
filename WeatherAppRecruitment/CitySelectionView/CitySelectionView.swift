//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

// MARK: CitySelectionView
final class CitySelectionView: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.register(cellWithClass: CitySelectionCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    private lazy var searchController: UISearchController = {
        let searchResultController = CitySearchView()
        searchResultController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var viewModel = CitySelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "city.list.title".localized
        viewModel.reloadData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    private func reloadData() {
        viewModel.reloadData()
        tableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        view.addSubviews([
            tableView,
            activityIndicatorView
        ])
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func goToDetails(_ selectedCity: SelectedCity) {
        activityIndicatorView.startAnimating()
        viewModel.loadDetailsData(from: selectedCity) { result in
            self.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let weatherData):
                self.searchController.searchBar.resignFirstResponder()
                self.searchController.searchBar.text = nil
                
                let vc = CityDetailsView()
                vc.actualWeatherData = weatherData
                vc.selectedCity = selectedCity
                
                self.navigationController?.show(vc, sender: nil)
            case .failure(_):
                self.presentErrorAlert()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CitySelectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: CitySelectionCell.self,
            for: indexPath)
        cell.selectionStyle = .none
        cell.customize(viewModel.savedCities[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CityWeatherStorage.shared.removeWeatherStorageObject(viewModel.savedCities[indexPath.row])
            reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = viewModel.savedCities[indexPath.row]
        
        goToDetails(SelectedCity(title: selectedCity.name,
                                 subtitle: selectedCity.country,
                                 lat: selectedCity.lat,
                                 long: selectedCity.long))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchResultsUpdating
extension CitySelectionView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard let vc = searchController.searchResultsController as? CitySearchView else { return }
        vc.searchCities(text)
    }
}

// MARK: - UISearchBarDelegate
extension CitySelectionView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            self.searchController.isActive = true
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var allowedCharacterSet = CharacterSet.whitespaces
        allowedCharacterSet.formUnion(CharacterSet.letters)
        if let unicoeScalar = text.unicodeScalars.first {
            if !allowedCharacterSet.contains(unicoeScalar) {
                return false
            }
        }
        
        return true
    }
}

// MARK: - UISearchControllerDelegate
extension CitySelectionView: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

// MARK: - CitySearchDelegate
extension CitySelectionView: CitySearchDelegate {
    func selectCity(_ selectedCity: SelectedCity) {
        goToDetails(selectedCity)
    }
}
