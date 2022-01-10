//
//  MainView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-09.
//

import Foundation
import SwiftUI

struct ContentView: View {
    enum Tab {
        case browse
        case orders
    }
    
    @EnvironmentObject var cartViewModel: CartViewModel
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif

    @State private var selection: Tab = .browse

    var body: some View {
        TabView(selection: $selection) {
            restaurantsView
            ordersView
        }
        .eraseToAnyView()
    }

    var personButton = Button(action: {print("person")}) {
        Image(systemName: "person")
    }

    var cartButton = Button(action: {print("cart")}) {
        Image(systemName: "cart")
    }
}

extension ContentView {
    var restaurantsView: some View {
        return RestaurantsView()
        .tabItem {
            Image(systemName: "magnifyingglass.circle.fill")
            Text("Browse")
        }
        .tag(Tab.browse)
        .eraseToAnyView()
    }

    var ordersView: some View {
        return OrdersView()
        .tabItem {
            Image(systemName: "list.bullet.rectangle.portrait.fill")
            Text("Orders")
        }
        .tag(Tab.orders)
        .eraseToAnyView()
    }
}
