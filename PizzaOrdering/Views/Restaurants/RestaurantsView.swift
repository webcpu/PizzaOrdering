//
//  RestaurantsView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation

struct RestaurantsView: View {
    @EnvironmentObject var appState: AppState
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @StateObject var viewModel = RestaurantsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.items, id: \.id) { restaurant in
                    NavigationLink(destination:
                                    RestaurantView(restaurantId: restaurant.id)) {
                        RestaurantRow(restaurant: restaurant)
                    }
                                    .listRowSeparator(.hidden)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .listStyle(GroupedListStyle())
                //.edgesIgnoringSafeArea(.all)
                //.navigationTitle("Restaurants Near Me" + location.description)
                
                if self.appState.cart != nil && self.appState.cart!.items.count > 0 {
                    VStack {
                        Spacer()
                        CartButton()
                    }
                }
            }
            .navigationTitle(viewModel.location.description)
        }
        .eraseToAnyView()
    }
}

struct RestaurantRow: View {
    let restaurant: Restaurant
    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }
    
    var body: some View {
        VStack {
            AsyncImage(url: pizzaURL,
                       content: { image in
                //                                GeometryReader { geo in
                image.resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 150)
                    .clipped()
                //                              }
            },
                       placeholder: {
                ProgressView()
            })
                .cornerRadius(10)
            HStack{
                Text(restaurant.name)
                //                Text(restaurant.name)
                Text("\(restaurant.latitude), \(restaurant.longitude)")
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
    }
}
