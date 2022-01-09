//
//  PizzaOrderingApp.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import SwiftUI


@main
struct PizzaOrderingApp: App {
    init() {
        LocationService.default.getCurrentLocation()
        
    //    UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CartModel().connect())
        }
    }
}
