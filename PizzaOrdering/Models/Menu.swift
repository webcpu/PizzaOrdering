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
    let price: Decimal
    let rank: Int?
}

extension Food {
    var imageName: String {
        let dict = ["Pizza": "pizza", "Tillbehör": "pizzasalad"]
        if let fileName = dict[category] {
            return fileName
        }
        
        if category.lowercased() == "dryck" {
            if name.lowercased().hasPrefix("coca-cola") {
                return "coke"
            } else if name.lowercased().hasPrefix("loka citron") {
                return "lokacitron"
            } else {
                return "coke"
            }
        }
        
        return "pizza"
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
