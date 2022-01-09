//
//  PizzaOrderingApp.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct PizzaOrderingApp: App {
    init() {
        LocationService.default.getCurrentLocation()
        
        dynamicLogLevel = DDLogLevel.info
        
        DDLog.add(DDOSLogger.sharedInstance)
    //    UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CartViewModel().connect())
        }
    }
}
