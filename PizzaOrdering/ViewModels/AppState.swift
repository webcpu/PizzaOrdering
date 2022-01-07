//
//  AppState.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation
import Combine

public class AppState: ObservableObject {
    @Published var restaurant: Restaurant?
    @Published var cart: Cart?
    @Published var subtotal: Decimal = 0
    @Published var quantity: Int = 0
    var bag = Set<AnyCancellable>()

    func connect() -> Self {
        $cart
            .compactMap({$0})
            .sink(receiveValue: {c in
                    print(c)
            })
            .store(in: &bag)
        return self
    }
    
    func addItem(food: Food, quantity: Int) {
        var items = cart!.items
        if let index = cart!.items.map({$0.menuItemId}).firstIndex(of: food.id) {
            var lineItem: LineItem = cart!.items[index]
            lineItem.quantity += quantity
            items[index] = lineItem
        } else {
            var lineItem = LineItem(menuItemId: food.id, quantity: 1)
            lineItem.price = food.price
            items.append(lineItem)
        }
        updateCart(items)
    }
    
    func removeItem(atOffsets offsets: IndexSet) {
        var items = cart?.items ?? []
        items.remove(atOffsets: offsets)
        updateCart(items)
    }
    
    func updateCart(_ items: [LineItem]) {
        cart!.items = items.filter({$0.quantity > 0})
        quantity = cart!.quantity
        subtotal = cart!.items.map({item in Decimal(item.quantity) * item.price!}).reduce(0, +)
    }
    
    func clearCart() {
        DispatchQueue.main.async {
            self.cart = nil
            self.quantity = 0
            self.subtotal = 0
        }
    }
    
    func createOrder() async -> OrderSummary? {
        guard let restaurantId = cart?.restaurantId,
              let items = cart?.items else {
                  return nil
              }
        let orderSummary = await BackendAPI.createOrder(restaurantId, items)
        clearCart()
        return orderSummary
    }
}
