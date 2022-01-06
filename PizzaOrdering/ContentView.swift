//
//  ContentView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        return Text("Hello, world!")
            .padding()
            .onAppear {
                async {
                    let rs = await BackendAPI.getRestaurants()
                    print(rs)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
