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
    let totalPrice: Int
    let orderedAt: String
    let esitmatedDelivery: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case totalPrice, orderedAt, esitmatedDelivery, status
    }
}

func ==(lhs: OrderSummary, rhs: OrderSummary) -> Bool {
    return lhs.orderID == lhs.orderID &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.orderedAt == rhs.orderedAt &&
    lhs.esitmatedDelivery == rhs.esitmatedDelivery &&
    lhs.status == rhs.status
}

//MARK: - LineItem
struct LineItem: Codable, Equatable {
    let menuItemId: Int
    let quantity: Int
}

func ==(lhs: LineItem, rhs: LineItem) -> Bool {
    return lhs.menuItemId == rhs.menuItemId &&
    lhs.quantity == rhs.menuItemId
}

//MARK: - Order
struct Order: Codable, Equatable{
    var orderID: UInt64// is it big enough?
    let totalPrice: Int
    let orderedAt: String
    let esitmatedDelivery: String
    let status: String
    
    let items: [LineItem]
    let restuarantId: Int
    
    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case totalPrice, orderedAt, esitmatedDelivery, status
        case items = "cart"
        case restuarantId = "restuarantId"
    }
}

func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.orderID == lhs.orderID &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.orderedAt == rhs.orderedAt &&
    lhs.esitmatedDelivery == rhs.esitmatedDelivery &&
    lhs.status == rhs.status
}
