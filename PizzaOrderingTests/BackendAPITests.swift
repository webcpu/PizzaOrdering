//
//  PizzaOrderingTests.swift
//  PizzaOrderingTests
//
//  Created by liang on 2022-01-05.
//

import XCTest
@testable import PizzaOrdering

class BackendAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRestaurants() async throws {
        let expected = TestData.restaurants
        let result   = await BackendAPI.getRestaurants()
        XCTAssertEqual(expected, result)
    }
    
    func testGetRestaurant() async throws {
        let expected = TestData.restaurant
        let id = 2
        let result   = await BackendAPI.getRestaurant(id)
        XCTAssertEqual(expected, result)
    }
    
    func testMenu() async throws {
        let expected = TestData.menu
        let restaurantId = 2
        let category = "Pizza"
        let orderBy = "rank"
        let result   = await BackendAPI.getMenu(restaurantId, category, orderBy)
        XCTAssertEqual(expected, result)
    }
    
    func testCreateOrder() async throws {
        let expected = TestData.newOrder
        let restaurantId = 1
        let lineItems: [LineItem] = [
            LineItem(menuItemId: 2, quantity: 1),
            LineItem(menuItemId: 3, quantity: 1),
            LineItem(menuItemId: 6, quantity: 2)]
        let result   = await BackendAPI.createOrder(restaurantId, lineItems)
        XCTAssertEqual(expected, result)
    }
    
    func testGetOrder() async throws {
        let expected = TestData.oldOrder
        let orderId = 1234412
        let result   = await BackendAPI.getOrder(orderId)
        XCTAssertEqual(expected, result)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

fileprivate class TestData {
    //restaurants
    static let restaurant1 = Restaurant(id: 2,
                                        name: "Pizza Heaven",
                                        address1: "Kungsgatan 1",
                                        address2: "111 43 Stockholm",
                                        latitude: 59.3360780,
                                        longitude: 18.0718070)
    static let restaurant2 = Restaurant(id: 1,
                                        name: "Pizzeria Apan",
                                        address1: "Långholmsgatan 34",
                                        address2: "117 33 Stockholm",
                                        latitude: 59.3157090,
                                        longitude: 18.0335070)
    static let restaurants: [Restaurant] = [restaurant1, restaurant2]
    
    //restaurant
    static let restaurant = Restaurant(id: 1,
                                       name: "Pizzeria Apan",
                                       address1: "Ljusslingan 4",
                                       address2: "120 31 Stockholm",
                                       latitude: 59.315709,
                                       longitude: 18.033507)
    //menu
    static let menu =
    [Food(id: 1, category: "Pizza", name: "Vesuvius", topping: Optional(["Tomat", "Ost", "Skinka"]), price: 79, rank: Optional(3)),
     Food(id: 2, category: "Pizza", name: "Hawaii", topping: Optional(["Tomat", "Ost", "Skinka", "Ananas"]), price: 79, rank: Optional(1)),
     Food(id: 3, category: "Pizza", name: "Parma", topping: Optional(["Tomat", "Ost", "Parmaskinka", "Oliver", "Färska basilika"]), price: 89, rank: Optional(2)),
     Food(id: 4, category: "Dryck", name: "Coca-cola, 33cl", topping: nil, price: 10, rank: nil),
     Food(id: 5, category: "Dryck", name: "Loka citron, 33cl", topping: nil, price: 10, rank: nil),
     Food(id: 6, category: "Tillbehör", name: "Pizzasallad", topping: nil, price: 0, rank: nil),
     Food(id: 7, category: "Tillbehör", name: "Bröd och smör", topping: nil, price: 10, rank: nil)]
    
    //new order
    static let newOrder = OrderSummary(
        orderID: 1234412,
        totalPrice: 168,
        orderedAt: "2015-04-09T17:30:47.556Z",
        esitmatedDelivery: "2015-04-09T17:45:47.556Z",
        status: "ordered")
    
    //old order
    static let oldOrder = Order(orderID: 1234412, totalPrice: 168, orderedAt: "2015-04-09T17:30:47.556Z", esitmatedDelivery: "2015-04-09T17:50:47.556Z", status: "baking", items: [PizzaOrdering.LineItem(menuItemId: 2, quantity: 1), PizzaOrdering.LineItem(menuItemId: 3, quantity: 1), PizzaOrdering.LineItem(menuItemId: 6, quantity: 2)], restuarantId: 1)
}

