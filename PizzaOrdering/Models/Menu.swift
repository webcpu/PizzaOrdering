//
//  Menu.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import Foundation

typealias Menu = [Food]

struct Food: Codable, Equatable {
    let id: Int
    let category: String
    let name: String
    let topping: [String]?
    let price: Int
    let rank: Int?
}

func ==(lhs: Food, rhs: Food) -> Bool {
    return lhs.id == lhs.id &&
    lhs.category == rhs.category &&
    lhs.name == rhs.name &&
    lhs.topping == rhs.topping &&
    lhs.price == rhs.price &&
    lhs.rank == rhs.rank
}
