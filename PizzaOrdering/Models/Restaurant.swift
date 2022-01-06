//
//  Restaurant.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let id: Int
    let name: String
    let address1: String
    let address2: String
    let latitude: Double
    let longitude: Double
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == lhs.id &&
    lhs.name == rhs.name &&
    lhs.address1 == rhs.address1 &&
    lhs.address2 == rhs.address2 &&
    lhs.latitude == rhs.latitude &&
    lhs.longitude == rhs.longitude
}
