//
//  OrdersViewModel.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation
import Combine
import SwiftLocation
import CoreLocation
import CocoaLumberjackSwift

class OrdersViewModel: ObservableObject {
    @Published var items = [Restaurant]()
    @Published var location: CLLocation = CLLocation()

    let locationService = LocationService.default

    private var cancellable: AnyCancellable?

    init() {
        if let loc = SwiftLocation.lastKnownGPSLocation {
            location = loc
        }
        locationService.getCurrentLocation()
        updateItems()
    }

    func updateItems() {
        cancellable = locationService.publisher
            .flatMap({loc in
                Future { promise in
                    Task {
                        let items = await BackendAPI.getRestaurants()
                        promise(.success((loc, items)))
                    }
                }
            })
            .sink(receiveValue: {(arg0: (CLLocation, [Restaurant])) -> Void in
                let (location, items) = arg0
                DDLogInfo("receiveValue: \(arg0)")
                DispatchQueue.main.async {
                    self.items = items.sorted(by: self.compareByDistance)
                    self.location = location
                }
            })
    }

    func compareByDistance(_ r1: Restaurant, r2: Restaurant) -> Bool {
        let distance1 = r1.distance(from: location)
        let distance2 = r2.distance(from: location)
        return distance1 < distance2
    }
}
