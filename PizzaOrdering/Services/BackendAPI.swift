//
//  BackendAPI.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import Foundation
import Alamofire

struct BackendAPI {
    static let baseURL = "https://private-anon-2665225972-pizzaapp.apiary-mock.com/"
    static let restaurantsURL = baseURL + "restaurants/"
    static let ordersURL = baseURL + "orders/"
    
    static func getRestaurantURL(_ id: Int) -> String {
        return restaurantsURL + String(id)
    }
    
    static func getMenuURL(_ restaurantId: Int, _ category: String, _ orderBy: String) -> String {
        return getRestaurantURL(restaurantId) + "/menu"
    }
    
    static func getOrderURL(_ orderId: Int) -> String {
        return ordersURL + String(orderId)
    }
    
    //static func getRestaurants() async -> DataResponse<[Restaurant], AFError> {
    static func getRestaurants() async -> [Restaurant] {
        let restaurants: [Restaurant] = await withCheckedContinuation {
            continuation in
            AF.request(restaurantsURL, method: .get)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Restaurant].self) {
                    (response: DataResponse<[Restaurant], AFError>) in
                    let dataset: [Restaurant] = response.value ?? []
                    continuation.resume(returning: dataset)
                }
        }
        return restaurants
    }
    
    //static func getRestaurant(_ id: Int) async -> DataResponse<Restaurant, AFError> {
    static func getRestaurant(_ id: Int) async -> Restaurant {
        let url = getRestaurantURL(id)
        let restaurant: Restaurant = await withCheckedContinuation {
            continuation in
            AF.request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Restaurant.self) {
                    (response: DataResponse<Restaurant, AFError>) in
                    let value: Restaurant = response.value!
                    continuation.resume(returning: value)
                }
        }
        return restaurant
    }
    
    //static func getMenu(_ restaurantId: Int, _ category: String, _ orderBy: String) async -> DataResponse<[Food], AFError> {
    static func getMenu(_ restaurantId: Int, _ category: String, _ orderBy: String) async -> [Food] {
        let url = getMenuURL(restaurantId, category, orderBy)
        let urlParams = [
            "category": category,
            "orderBy": orderBy,
        ]
        let menu : [Food] = await withCheckedContinuation {
            continuation in
            AF.request(url, method: .get, parameters: urlParams)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Food].self) {
                    (response: DataResponse<[Food], AFError>) in
                    let value: [Food] = response.value ?? []
                    continuation.resume(returning: value)
                }
        }
        return menu
    }
    
    static func createOrder(_ restaurantId: Int, _ lineItems: [LineItem]) async -> OrderSummary {
        let url = ordersURL
        let headers = HTTPHeaders([
            "Content-Type":"application/json; charset=utf-8",
        ])
        let cart = Cart(items: lineItems, restuarantId: restaurantId)
        let body: [String: Any] = (try? cart.toDictionary()) ?? [:]
        let orderResponse : OrderSummary = await withCheckedContinuation {
            continuation in
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: OrderSummary.self) {
                    (response: DataResponse<OrderSummary, AFError>) in
                    let value: OrderSummary = response.value!
                    continuation.resume(returning: value)
                }
        }
        return orderResponse
    }
    
    static func getOrder(_ id: Int) async -> Order? {
        let url = getOrderURL(id)
        let order: Order? = await withCheckedContinuation {
            continuation in
            AF.request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Order.self) {
                    (response: DataResponse<Order, AFError>) in
                    let value: Order? = response.value
                    print(value!)
                    continuation.resume(returning: value)
                }
        }
        return order
    }
}
