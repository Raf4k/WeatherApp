//
//  CitySearchView.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import UIKit
import MapKit

// MARK: - CitySearchDelegate
protocol CitySearchDelegate: AnyObject {
    func selectCity(_ selectedCity: SelectedCity)
}

// MARK: - CitySearchView
final class CitySearchView: UIViewController {
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
                CityWeatherStorage.shared.saveNewSearchedCities(title: selectedCity.title,
                                                                subtitle: selectedCity.subtitle,
                                                                lat: item.placemark.coordinate.latitude,
                                                                long: item.placemark.coordinate.longitude)
                
                self.delegate?.selectCity(SelectedCity(title: selectedCity.title,
                                                       subtitle: selectedCity.subtitle,
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

// MARK: - MKLocalSearchCompleterDelegate
extension CitySearchView: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResultArray = completer.results.filter({ result in
            if result.title.contains(",") {
                return false
            }
            if result.subtitle.isEmpty {
                return false
            }
            if result.subtitle.contains(",") {
                return false
            }
            return true
            
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CitySearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchCompleter.queryFragment.isEmpty {
            return CityWeatherStorage.shared.allSearchedCities().count
        } else {
            return searchResultArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        searchCompleter.queryFragment.isEmpty ? "search.city.title.last".localized : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: CitySearchCell.self,
            for: indexPath)
        cell.selectionStyle = .none
        
        if searchCompleter.queryFragment.isEmpty {
            cell.customize(CityWeatherStorage.shared.allSearchedCities()[indexPath.row])
        } else {
            cell.customize(searchResultArray[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCity = MKLocalSearchCompletion()
        
        if searchCompleter.queryFragment.isEmpty {
            let searchedItem = CityWeatherStorage.shared.allSearchedCities()[indexPath.row]
            self.delegate?.selectCity(SelectedCity(title: searchedItem.title,
                                                   subtitle: searchedItem.subtitle,
                                                    lat: searchedItem.lat,
                                                    long: searchedItem.long))
        } else {
            selectedCity = searchResultArray[indexPath.row]
            findSelectedCityDetails(selectedCity)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
