//
//  CityWeatherStorage.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 11/09/2023.
//

import Foundation
import CoreData

class CityWeatherStorage {
    static let shared = CityWeatherStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherAppRecruitment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

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
    
    func saveNewSearchedCities(title: String, subtitle: String) {
        let allCities = allSearchedCities()
        if allCities.count == 5 {
            removeWeatherStorageObject(allCities.last)
        }
        let newCity = SearchedCities(context: persistentContainer.viewContext)
        newCity.title = title
        newCity.subtitle = subtitle
        newCity.date = Date()
        
        saveContext()
    }
}
