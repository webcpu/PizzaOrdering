//
//  AddButton.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import Foundation
import SwiftUI
import Combine

struct AddItemButton: View {
    var food: Food
    var restaurant: Restaurant
    @State var quantity: Int = 0
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(restaurant: Restaurant, food: Food) {
        self.restaurant = restaurant
        self.food = food
    }
        
    var body: some View {
        Button(action: {
            print("add")
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
            .padding(.horizontal, 10)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 44)
        .background(Color.pink)
        .padding(.horizontal,  20)
        .padding(.vertical,  5)
    }
    
    fileprivate func addItem() {
        dump(appState.cart?.items)
        appState.addItem(food: food, quantity: 1)
    }

}
