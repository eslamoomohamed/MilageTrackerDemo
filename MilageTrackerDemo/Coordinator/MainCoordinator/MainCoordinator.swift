//
//  MainCoordinator.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit

class MainCoordinator: BaseCoordinator,UINavigationControllerDelegate{
    
    
    override init(navigationController: UINavigationController){
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        makeHomeVCCoordinator()
    }
    
    func makeHomeVCCoordinator(){
        let HomeVCNavigationController      = navigationController
        HomeVCNavigationController.delegate = self
        let child = HomeVCCoordinator(navigationController: HomeVCNavigationController)
        addChildCoordinator(child)
        child.parentCoordinator = self
        child.start()
    }

    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in
                childCoordinators.enumerated(){
            if coordinator === child{
                removeChildCoordinator(index)
                break
            }
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else{return}
        guard let toViewController   = navigationController.transitionCoordinator?.viewController(forKey: .to) else { return}
        print("from ViewController \(fromViewController)\n")
        print("to ViewController \(toViewController) \n")
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        

    }
    
    
}

