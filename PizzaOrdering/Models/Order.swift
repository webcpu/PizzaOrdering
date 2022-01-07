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
    let orderedAt: String
    let estimatedDelivery: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case estimatedDelivery = "esitmatedDelivery"
        case totalPrice, orderedAt, status
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
    let totalPrice: Int
    let orderedAt: String
    let estimatedDelivery: String
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
}

func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.orderID == lhs.orderID &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.orderedAt == rhs.orderedAt &&
    lhs.estimatedDelivery == rhs.estimatedDelivery &&
    lhs.status == rhs.status
}
