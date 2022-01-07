//
//  Restaurant.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import Foundation
import CoreLocation

struct Restaurant: Codable, Equatable {
    let id: Int
    let name: String
    let address1: String
    let address2: String
    let latitude: Double
    let longitude: Double
}

extension Restaurant {
    func getLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        return abs(getLocation().distance(from: location))
    }
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == lhs.id &&
    lhs.name == rhs.name &&
    lhs.address1 == rhs.address1 &&
    lhs.address2 == rhs.address2 &&
    lhs.latitude == rhs.latitude &&
    lhs.longitude == rhs.longitude
}
