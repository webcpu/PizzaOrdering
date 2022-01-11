//
//  Food.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import Foundation
import UIKit

typealias Menu = [Food]

struct Food: Codable, Equatable {
    let id: Int
    let category: String
    let name: String
    let topping: [String]?
    let price: Decimal
    let rank: Int?
}

extension Food {
    fileprivate func getDrinkImageName() -> String {
        let name = name.lowercased()
        if name.hasPrefix("coca-cola") {
            return "coke"
        } else if name.hasPrefix("loka citron") {
            return "lokacitron"
        } else {
            return "coke"
        }
    }
    
    fileprivate func getAccessoryImageName() -> String {
        let name = name.lowercased()
        if name.hasPrefix("pizzasallad") {
            return "pizzasalad"
        } else if name.hasPrefix("bröd") {
            return "breadbutter"
        } else {
            return "breadbutter"
        }
    }
    
    var imageName: String {
        let category = category.lowercased()
        switch category {
        case "pizza":
            return "pizza"
        case "dryck":
            return getDrinkImageName()
        case "tillbehör":
            return getAccessoryImageName()
        default:
            return "pizza"
        }
    }
    
    func matches(_ string: String) -> Bool {
        string.isEmpty ||
        name.localizedCaseInsensitiveContains(string) ||
        (topping != nil && topping!.contains {
            $0.localizedCaseInsensitiveContains(string)
        })
    }
}

extension Food {
    static var dummyFood: Food {
        return Food(id: 0, category: "", name: "", topping: [], price: 0, rank: 0)
    }
}



func ==(lhs: Food, rhs: Food) -> Bool {
    return lhs.id == lhs.id &&
    lhs.category == rhs.category &&
    lhs.name == rhs.name &&
    lhs.topping == rhs.topping &&
    lhs.price == rhs.price &&
    lhs.rank == rhs.rank
}
