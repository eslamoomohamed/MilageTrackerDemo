//
//  BaseCoordinator.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit
class BaseCoordinator: NSObject,Coordinator{
    
    private(set) var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        //Start func will be override in all coordinators that will inherit
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func getViewControllerToShow() -> UIViewController{
        return navigationController
    }
    
    func getCurrentShowedVC() -> UIViewController?{
        return getViewControllerToShow().presentedViewController
    }
    
    func getChildCoordinator(_ index: Int) -> Coordinator? {
        if index >= 0 {
            return childCoordinators[index]
        } else {
            return nil
        }
    }
    
    func removeChildCoordinator(_ index:Int) {
        print("index that will be deleted is \(index) \n")
        print("value that will be deleted is \(childCoordinators[index]) \n")
        childCoordinators.remove(at: index)
    }
    
}
