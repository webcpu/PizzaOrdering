//
//  Order.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation

//MARK: - OrderSummary
struct OrderSummary: Codable, Equatable{
    //FIXME: - is UInt64 big enough for orderID?
    let orderID: UInt64
    let totalPrice: Decimal
    let orderedAt: Date
    let estimatedDelivery: Date
    let status: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case estimatedDelivery = "esitmatedDelivery"
        case totalPrice, orderedAt, status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        orderID = try values.decode(UInt64.self, forKey: .orderID)
        totalPrice = try values.decode(Decimal.self, forKey: .totalPrice)
        
        let orderedAtString = try values.decode(String.self, forKey: .orderedAt)
        orderedAt = Date.fromISODateString(orderedAtString) ?? Date.distantPast
        
        let estimatedDeliveryString = try values.decode(String.self, forKey: .estimatedDelivery)
        estimatedDelivery = Date.fromISODateString(estimatedDeliveryString) ?? Date.distantPast
        status = try values.decode(String.self, forKey: .status)
    }

    
    init(orderID: UInt64, totalPrice: Decimal, orderedAt: Date, estimatedDelivery: Date, status: String) {
        self.orderID = orderID
        self.totalPrice = totalPrice
        self.orderedAt = orderedAt
        self.estimatedDelivery = estimatedDelivery
        self.status = status
    }

}

func ==(lhs: OrderSummary, rhs: OrderSummary) -> Bool {
    return lhs.orderID == lhs.orderID &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.orderedAt == rhs.orderedAt &&
    lhs.estimatedDelivery == rhs.estimatedDelivery &&
    lhs.status == rhs.status
}

//MARK: - LineItem
struct LineItem: Codable, Equatable {
    let menuItemId: Int
    var quantity: Int
    var price: Decimal?
    
    var sum: Decimal {
        return (price ?? 0) * Decimal(quantity)
    }
}

func ==(lhs: LineItem, rhs: LineItem) -> Bool {
    return lhs.menuItemId == rhs.menuItemId &&
    lhs.quantity == rhs.quantity
}

//MARK: - Order
struct Order: Codable, Equatable{
    var orderID: UInt64// is it big enough?
    let totalPrice: Decimal
    let orderedAt: Date
    let estimatedDelivery: Date
    let status: String
    
    let items: [LineItem]
    let restaurantId: Int
    
    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case totalPrice, orderedAt, status
        case estimatedDelivery = "esitmatedDelivery"
        case items = "cart"
        case restaurantId = "restuarantId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        orderID = try values.decode(UInt64.self, forKey: .orderID)
        totalPrice = try values.decode(Decimal.self, forKey: .totalPrice)
        
        let orderedAtString = try values.decode(String.self, forKey: .orderedAt)
        orderedAt = Date.fromISODateString(orderedAtString) ?? Date.distantPast
        
        let estimatedDeliveryString = try values.decode(String.self, forKey: .estimatedDelivery)
        estimatedDelivery = Date.fromISODateString(estimatedDeliveryString) ?? Date.distantPast
        status = try values.decode(String.self, forKey: .status)
        items = try values.decode([LineItem].self, forKey: .items)
        restaurantId = try values.decode(Int.self, forKey: .restaurantId)
    }
    
    init(orderID: UInt64, totalPrice: Decimal, orderedAt: Date, estimatedDelivery: Date, status: String, items: [LineItem], restaurantId: Int) {
        self.orderID = orderID
        self.totalPrice = totalPrice
        self.orderedAt = orderedAt
        self.estimatedDelivery = estimatedDelivery
        self.status = status
        self.items = items
        self.restaurantId = restaurantId
    }
    
    var quantity: Int {
        return items.map({$0.quantity}).reduce(0, +)
    }
}

func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.orderID == lhs.orderID &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.orderedAt == rhs.orderedAt &&
    lhs.estimatedDelivery == rhs.estimatedDelivery &&
    lhs.status == rhs.status
}
