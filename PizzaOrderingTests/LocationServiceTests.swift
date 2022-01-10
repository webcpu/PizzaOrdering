//
//  LocationServiceTests.swift
//  PizzaOrderingTests
//
//  Created by liang on 2022-01-06.
//

import XCTest
import Combine
import CoreLocation
@testable import PizzaOrdering

class LocationServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentLocation() throws {
        //Vasaplan 4, 111 20 Stockholm
        //https://www.latlong.net/convert-address-to-lat-long.html
        let locationService = LocationService.default
        let expected = CLLocation(latitude: 59.332400, longitude: 18.057240)
        let expectation = XCTestExpectation(description: "Publishes one value then finishes")

        var bag = Set<AnyCancellable>()

        locationService.getCurrentLocation()
        locationService.publisher
            .sink(
                receiveCompletion: { completion in
                    guard case .finished = completion else { return }
                    expectation.fulfill()
                },
                receiveValue: { (value: CLLocation) -> Void in
                    XCTAssertEqual(expected, value)
                    //values.append(value)
                })
            .store(in: &bag)

        wait(for: [expectation], timeout: 0.5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
