//
//  CoreDataManager.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 20/07/2022.
//

import Foundation
import CoreData
import MapKit

class CoreDataManager{
    
    
    static let shared = CoreDataManager()
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TripModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert(trip: TripCellViewModel){
        let managedObjectContext = persistentContainer.viewContext
        let entity          = NSEntityDescription.entity(forEntityName: "TripModel", in: managedObjectContext)!
        let tripModel = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        tripModel.setValue(trip.tripName, forKey: "name")
        tripModel.setValue(trip.tripStartPoint.longitude, forKey: "startLocationLong")
        tripModel.setValue(trip.tripStartPoint.latitude, forKey: "startLocationLatitu")
        tripModel.setValue(trip.tripEndPoint.longitude, forKey: "endLocationLong")
        tripModel.setValue(trip.tripEndPoint.latitude, forKey: "endLocationLatitu")
        
        do{
            try managedObjectContext.save()
            print("new trip saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getAllTrips() -> [TripCellViewModel]
    {
        let context = self.persistentContainer.viewContext
        var objects:[NSManagedObject] = []
        var products:[TripCellViewModel] = []
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "TripModel")
        do{
            objects = try context.fetch(fetchReq)
            for trips in objects{
                let t = TripCellViewModel(tripName: trips.value(forKey: "name")as! String , tripStartPoint: CLLocationCoordinate2D(latitude: trips.value(forKey: "startLocationLatitu")as! Double, longitude: trips.value(forKey: "startLocationLong")as! Double), tripEndPoint: CLLocationCoordinate2D(latitude: trips.value(forKey: "endLocationLatitu")as! Double, longitude: trips.value(forKey: "endLocationLong")as! Double))
                products.append(t)
            }
        }catch let error as NSError{
            print(error)
        }
        return products
    }
    
    
}
