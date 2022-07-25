//
//  StoryboardLoad.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit

protocol StoryboardLoad{
    static var storyboardID: String { get }
    
    static var storyboardControllerID: String { get }
}

extension StoryboardLoad where Self: UIViewController{
    static var storyboardID: String{
        return String(describing: Self.self)
    }
    
    static var storyboardControllerID: String{
        return String(describing: Self.self)
    }
    
    static func instaniateStoryboard()-> Self{
        let storyboard = UIStoryboard(name: Self.storyboardID , bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardControllerID) as! Self
    }
    
}
