//
//  HomeViewModel.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import Foundation

protocol IHomeViewModel{
    func getTripCellViewModel(at index: IndexPath) -> TripCellViewModel
    func getNumberOfCells() -> Int
    func fetchTripsFromCoreData()
    var trips: [TripCellViewModel]  { get set }
    var updateTableViewClosure: ()->()  { get set }
}

class HomeViewModel:IHomeViewModel{

    
    
    var trips: [TripCellViewModel] = []{
        didSet{
            self.updateTableViewClosure()
        }
    }
    
    
    var updateTableViewClosure: ()->() = {}
    
    
    
    func getTripCellViewModel(at index: IndexPath) -> TripCellViewModel {
        return trips[index.row]
    }
    
    func getNumberOfCells() -> Int{
        return trips.count
    }
    
    func fetchTripsFromCoreData(){
        self.trips = CoreDataManager.shared.getAllTrips()
    }
    
}
