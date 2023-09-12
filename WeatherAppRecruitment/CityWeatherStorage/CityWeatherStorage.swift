//
//  CityWeatherStorage.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import Foundation
import CoreData

// MARK: - CityWeatherStorage
class CityWeatherStorage {
    static let shared = CityWeatherStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherAppRecruitment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //TODO: Add error handling propagation
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                //TODO: Add error handling propagation
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - CityWeatherStorage Modifications
extension CityWeatherStorage {
    func allSavedCities() -> [Cities] {
        do {
            return try persistentContainer.viewContext.fetch(Cities.fetchRequest())
        } catch {
            return []
        }
    }
    
    func allSearchedCities() -> [SearchedCities] {
        do {
            let request = SearchedCities.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: #keyPath(SearchedCities.date), ascending: false)
            request.sortDescriptors = [sortDescriptor]
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func removeWeatherStorageObject(_ object: NSManagedObject?) {
        guard let objectToRemove = object else { return }
        persistentContainer.viewContext.delete(objectToRemove)
        saveContext()
    }
    
    func removeSavedCity(savedCity: SelectedCity?) {
        let objToRemove = allSavedCities().filter { $0.name == savedCity?.title }.first
        removeWeatherStorageObject(objToRemove)
    }
    
    func cityWasSaved(_ name: String) -> Bool {
        return !allSavedCities().filter { $0.name == name }.isEmpty
    }
    
    func saveNewCity(name: String,
                     country: String,
                     lat: Double,
                     long: Double) {
        let newCity = Cities(context: persistentContainer.viewContext)
        newCity.name = name
        newCity.country = country
        newCity.lat = lat
        newCity.long = long
        
        saveContext()
    }
    
    func saveNewSearchedCities(title: String,
                               subtitle: String,
                               lat: Double,
                               long: Double) {
        let allCities = allSearchedCities()
        if allCities.count == 5 {
            removeWeatherStorageObject(allCities.last)
        }
        let newCity = SearchedCities(context: persistentContainer.viewContext)
        newCity.title = title
        newCity.subtitle = subtitle
        newCity.lat = lat
        newCity.long = long
        newCity.date = Date()
        
        saveContext()
    }
}
