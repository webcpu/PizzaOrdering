//
//  PizzaOrderingApp.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import SwiftUI


@main
struct PizzaOrderingApp: App {
//    var appState: AppState = AppState().connect()
    
    init() {
        LocationService.default.getCurrentLocation()
        
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            RestaurantsView().environmentObject(AppState().connect())
            //RestaurantView()
        }
    }
}
