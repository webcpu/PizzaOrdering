//
//  Cart.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation

struct Cart: Codable {
    var items: [LineItem]
    let restaurantId: Int

    enum CodingKeys: String, CodingKey {
        case items = "cart"
        case restaurantId = "restaurantId"
    }
    
    var quantity: Int {
        return items.map({$0.quantity}).reduce(0, +)
    }
    
    var subtotal: Decimal {
        return items.map({Decimal($0.quantity) * $0.price!}).reduce(0, +)
    }
    
    var isDummy: Bool {
        return self.restaurantId == 0
    }
    
    static var dummyCart: Cart {
        return Cart(items: [], restaurantId: 0)
    }
}

func ==(lhs: Cart, rhs: Cart) -> Bool {
    return lhs.items == rhs.items &&
    lhs.restaurantId == rhs.restaurantId
}
