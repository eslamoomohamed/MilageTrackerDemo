//
//  HomeVCCoordinator.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit

class HomeVCCoordinator:BaseCoordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    override init(navigationController: UINavigationController){
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let vc = HomeVC.instaniateStoryboard()
        vc.coordinator = self
        vc.pushVC = {  [weak self] VCName ,showRoute,cellVM in
            switch VCName{
            case "MapVC":
                if let cellVM = cellVM{
                    self?.pushMapVC(showRoute: showRoute, cellVM: cellVM)
                }else{
                    self?.pushMapVC(showRoute: showRoute, cellVM: nil)
                }
                
            default:
                print("invalid name")
            }
        }
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toPresent() -> UIViewController{
        return navigationController
    }
    
    func pushMapVC(showRoute:Bool,cellVM:TripCellViewModel?){
        print("map")
        let vc = MapVC.instaniateStoryboard()
        vc.coordinator = self
        vc.showRoute = showRoute
        vc.cellVmData = cellVM
        navigationController.pushViewController(vc, animated: true)
    }
    
}
