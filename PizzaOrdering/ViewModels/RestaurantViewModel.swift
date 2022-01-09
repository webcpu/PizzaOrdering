//
//  RestaurantViewModel.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation
import Combine
import SwiftLocation
import CoreLocation

class RestaurantViewModel: ObservableObject {
    @Published var restaurant: Restaurant
    @Published var items: [Food] = []
    
    private var cancellable: AnyCancellable?
    
    init(_ restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    func update() async {
        //self.restaurant = restaurant //await BackendAPI.getRestaurant(restaurantId)
        self.items = await BackendAPI.getMenu(restaurant.id, "Pizza", "rank")
    }
    
//    func updateItems() {
//
//        cancellable = $restaurant
//            .flatMap({r in
//                Future { promise in
//                    Task {
//                        let items = await BackendAPI.getRestaurant(r.id)
//                        promise(.success(items))
//                    }
//                }
//            })
//            .sink(receiveValue:
//                    {(items: [Food]) -> Void in
//                DDLogInfo("receiveValue: \(items)")
//                DispatchQueue.main.async {
//                    self.items = items //items.sorted(by: self.compareByDistance)
//                }
//            })
//    }
//    func compareByDistance(_ r1: Restaurant, r2: Restaurant) -> Bool {
//        let distance1 = r1.distance(from: location)
//        let distance2 = r2.distance(from: location)
//        return distance1 < distance2
//    }
}
