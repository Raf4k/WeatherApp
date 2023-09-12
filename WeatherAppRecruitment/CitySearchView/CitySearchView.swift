//
//  CitySearchView.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit
import MapKit

protocol CitySearchDelegate: AnyObject {
    func goToDetails(_ selectedCity: SelectedCity)
}

class CitySearchView: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .singleLine
        tableView.register(cellWithClass: CitySearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.resultTypes = .address
        searchCompleter.delegate = self
        return searchCompleter
    }()
    
    private var searchResultArray = [MKLocalSearchCompletion]()
    weak var delegate: CitySearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func findSelectedCityDetails(_ selectedCity: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: selectedCity)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            
            self.dismiss(animated: true) {
                self.delegate?.goToDetails(SelectedCity(name: item.name,
                                                        lat: item.placemark.coordinate.latitude,
                                                        long: item.placemark.coordinate.longitude))
            }
        }
    }
    
    func searchCities(_ text: String) {
        searchCompleter.queryFragment = text
        if text.isEmpty {
            searchResultArray.removeAll()
            tableView.reloadData()
        }
    }
}

extension CitySearchView: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResultArray = completer.results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension CitySearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultArray.isEmpty {
            return CityWeatherStorage.shared.allSearchedCities().count
        } else {
            return searchResultArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        searchResultArray.isEmpty ? "search.city.title.last".localized : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: CitySearchCell.self,
            for: indexPath)
        cell.selectionStyle = .none
        if searchResultArray.isEmpty {
            cell.customize(CityWeatherStorage.shared.allSearchedCities()[indexPath.row])
        } else {
            cell.customize(searchResultArray[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResultArray[indexPath.row]
        CityWeatherStorage.shared.saveNewSearchedCities(title: selectedCity.title, subtitle: selectedCity.subtitle)
        findSelectedCityDetails(selectedCity)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
