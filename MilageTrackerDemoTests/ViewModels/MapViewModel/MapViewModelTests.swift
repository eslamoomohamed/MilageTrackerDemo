//
//  MapViewModelTests.swift
//  MilageTrackerDemoTests
//
//  Created by eslam mohamed on 16/07/2022.
//

import XCTest
import MapKit
@testable import MilageTrackerDemo

class MapViewModelTests: XCTestCase {

    var viewModel: IMapViewModel!


    override func setUpWithError() throws {
        viewModel = MapViewModel()

    }

    override func tearDownWithError() throws {
        viewModel = nil

    }
    
    func testMapViewModel_getTimerCount() throws {
        XCTAssertEqual(viewModel.getTimerCount(), 300)
    }
    

}

