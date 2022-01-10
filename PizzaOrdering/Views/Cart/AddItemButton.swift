//
//  AddButton.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import Foundation
import SwiftUI
import Combine
import CocoaLumberjackSwift

struct AddItemButton: View {
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif

    var food: Food
    var restaurant: Restaurant
    @State var quantity: Int = 0

    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(restaurant: Restaurant, food: Food) {
        self.restaurant = restaurant
        self.food = food
    }

    var body: some View {
        Button(action: {
            DDLogInfo("add")
            addItem()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "cube.box").accentColor(.white)
                Spacer()
                Text("Add \(1) to cart").foregroundColor(.white)
                Spacer()
                Text("SEK \(food.price.description)").foregroundColor(.white)
            }
            .font(.headline)
            .cornerRadius(5)
            .padding(.horizontal, 10)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 44)
        .background(Color.pink)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .accessibility(identifier: "addFood")
        .eraseToAnyView()
    }

    fileprivate func addItem() {
        dump(cartViewModel.cart.items)
        cartViewModel.addItem(food: food, quantity: 1)
    }

}
