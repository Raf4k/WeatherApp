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

class CitySelectionView: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.register(cellWithClass: CitySelectionCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
    
    private let viewModel = CitySelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Weather"
        viewModel.reloadData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reloadData()
        tableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = viewModel.savedCities[indexPath.row]
        goToDetails(SelectedCity(name: selectedCity.name, lat: selectedCity.lat, long: selectedCity.long))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CitySelectionView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard let vc = searchController.searchResultsController as? CitySearchView else { return }
        vc.searchCities(text)
    }
}

extension CitySelectionView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            self.searchController.isActive = true
        }
        
        return true
    }
}

extension CitySelectionView: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

extension CitySelectionView: CitySearchDelegate {
    func goToDetails(_ selectedCity: SelectedCity) {
        let vc = CityDetailsView()
        vc.selectedCity = selectedCity
        
        navigationController?.show(vc, sender: nil)
    }
}
