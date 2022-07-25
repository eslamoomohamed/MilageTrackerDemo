//
//  MapViewModel.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import Foundation
import CoreLocation

protocol IMapViewModel{
    func getTimerCount() -> Int
    func saveTrip(startPoint: tripPoint, endPoint: tripPoint)
    
}

class MapViewModel:IMapViewModel{
    
    
    func getTimerCount() -> Int{
        return 10
    }
    
    func saveTrip(startPoint: tripPoint, endPoint: tripPoint){
            let cellVM = TripCellViewModel(tripName: "trip", tripStartPoint: CLLocationCoordinate2D(latitude: startPoint.latitu, longitude: startPoint.long), tripEndPoint: CLLocationCoordinate2D(latitude: endPoint.latitu, longitude: endPoint.long))
        CoreDataManager.shared.insert(trip: cellVM)
        
        print(CoreDataManager.shared.getAllTrips())
}
}
