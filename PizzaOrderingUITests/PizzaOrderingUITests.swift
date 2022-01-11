//
//  PizzaOrderingUITests.swift
//  PizzaOrderingUITests
//
//  Created by liang on 2022-01-05.
//

import XCTest
import SwiftUI

class PizzaOrderingUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func selectView(_ app: XCUIApplication, _ viewName: String) {
        let tabBar = app.tabBars["Tab Bar"]
        let button = tabBar.buttons[viewName]
        button.tap()
        //XCTAssertTrue(button.isSelected)
    }
    
    func selectRestaurantsView(_ app: XCUIApplication) {
        selectView(app, "Browse")
    }
    
    func selectOrdersView(_ app: XCUIApplication) {
        selectView(app, "Orders")
    }

    func testTabView() throws {
        let app = XCUIApplication()
        app.launch()

        selectRestaurantsView(app)
        selectOrdersView(app)
        selectRestaurantsView(app)
    }
    
    func testPlacingOrder() {
        let app = XCUIApplication()
        app.launch()
        
        selectRestaurantsView(app)
        getRestaurant(at: 0, app).tap()
        getFood(at: 0, app).tap()
        app.buttons["addFood"].tap()
        verifyCart(app)
        app.buttons["order"].tap()
        verifyOrderSummary(app)
    }
    
    func getRestaurant(at index: Int, _ app: XCUIApplication) -> XCUIElement {
        let restaurant = app.buttons["restaurant\(index)"]
        XCTAssertTrue(restaurant.isHittable)
        return restaurant
    }
    
    func getFood(at index: Int, _ app: XCUIApplication) -> XCUIElement {
        let food = app.buttons["food\(index)"]
        XCTAssertTrue(food.isHittable)
        return food
    }
    
    func verifyOrderSummary(_ app: XCUIApplication) {
        let orderTotalPrice = app.staticTexts["summary.Total Price"]
        XCTAssertEqual(orderTotalPrice.label, "SEK 168.00")
        
        let orderStatusText = app.staticTexts["summary.Status"]
        XCTAssertEqual(orderStatusText.label, "Ordered")
    }
    
    func verifyCart(_ app: XCUIApplication) {
        let viewCartText = app.staticTexts["viewCart"]
        XCTAssertEqual(viewCartText.label, "View cart (1)")
        let showCartButton = app.buttons["showCart"]
        showCartButton.tap()
        let subtotalText = app.staticTexts["cart.subtotal"]
        XCTAssertTrue(subtotalText.waitForExistence(timeout: 2))
        XCTAssertEqual(subtotalText.label, "SEK 79.00")
    }
   
    func testViewOrder() {
        let app = XCUIApplication()
        app.launch()
        
        selectOrdersView(app)
        getOrder(at: 0, app).tap()
        verifyOrderDetail(app)
    }
    
    func testPlacingOrderFromOldOrder() {
        let app = XCUIApplication()
        app.launch()
        
        selectOrdersView(app)
        getOrder(at: 0, app).tap()
        verifyOrderDetail(app)

        selectViewShop(app)
        
        getFood(at: 0, app).tap()
        app.buttons["addFood"].tap()
        verifyCart(app)
        app.buttons["order"].tap()
        verifyOrderSummary(app)
    }
    
    fileprivate func getOrder(at index: Int, _ app: XCUIApplication) -> XCUIElement {
        let button = app.buttons["order\(index)"]
        XCTAssertTrue(button.isHittable)
        return button
    }
    
    fileprivate func verifyOrderDetail(_ app: XCUIApplication) {
        let restaurantNameText = app.staticTexts["order.restaurant.name"]
        XCTAssertTrue(restaurantNameText.waitForExistence(timeout: 2.0))
        XCTAssertEqual(restaurantNameText.label, "Pizzeria Apan")
        
        let totalText = app.staticTexts["order.total"]
        XCTAssertEqual(totalText.label, "Total: SEK 168.00")
        
        let orderStatusText = app.staticTexts["order.status"]
        XCTAssertEqual(orderStatusText.label, "Baking")
    }

    fileprivate func selectViewShop(_ app: XCUIApplication) {
        let viewShopButton = app.buttons["order.viewshop"]
        viewShopButton.tap()
    }
    
    func xtestLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
