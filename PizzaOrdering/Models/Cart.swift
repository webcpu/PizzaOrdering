//
//  Cart.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation

struct Cart: Codable {
    let items: [LineItem]
    let restuarantId: Int

    enum CodingKeys: String, CodingKey {
        case items = "cart"
        case restuarantId = "restuarantId"
    }
}
