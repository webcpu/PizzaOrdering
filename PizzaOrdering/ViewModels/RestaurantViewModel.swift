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
    @Published var searchString = ""

    private var cancellable: AnyCancellable?

    init(_ restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    func update() async {
        self.items = await BackendAPI.getMenu(restaurant.id, "Pizza", "rank")
    }
    
    var searchSuggestions: [Food] {
        items.filter {
            $0.name.localizedCaseInsensitiveContains(searchString) &&
            $0.name.localizedCaseInsensitiveCompare(searchString) != .orderedSame
        }
    }
}
