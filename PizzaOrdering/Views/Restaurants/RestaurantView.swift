//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation

struct RestaurantView: View {
    @EnvironmentObject var appState: AppState
    @State var restaurantId: Int
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @StateObject var viewModel: RestaurantViewModel
    
    init(restaurantId: Int) {
        self.restaurantId = restaurantId
        self._viewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantId))
    }
    
    var body: some View {
        ZStack {
            List {
                Section() {
                    Text("Hi")
                }
                ForEach(viewModel.items, id: \.id) { item in
                    if viewModel.restaurant != nil {
                        NavigationLink(destination: FoodView(restaurant: viewModel.restaurant!, food: item)) {
                            FoodRow(restaurant: viewModel.restaurant!, food: item)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .listStyle(.insetGrouped)
                //            .listStyle(GroupedListStyle())
            }
//            if appState.cart != nil && appState.cart!.quantity > 0 {
                VStack {
                    Spacer()
                    CartButton()
                }
 //           }
        }
        //        .background(.clear)
        //.navigationTitle("Restaurants Near Me" + location.description)
        //            .navigationTitle(viewModel.location.description)
        .navigationTitle(viewModel.restaurant?.name ?? "")
        .task {
            if self.appState.cart == nil { //}|| self.appState.cart?.restaurantId != self.appState.restaurant?.id {
                self.appState.restaurant = viewModel.restaurant
                self.appState.cart = Cart(items: [], restaurantId: restaurantId)
            }
            await viewModel.update()
            self.appState.restaurant = viewModel.restaurant
        }
        .edgesIgnoringSafeArea(.horizontal)
        .colorMultiply(.white)
        .eraseToAnyView()
    }
}

struct FoodRow: View {
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    let restaurant: Restaurant
    let food: Food
    
    init(restaurant: Restaurant, food: Food) {
        self.restaurant = restaurant
        self.food = food
    }
    
    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Spacer()
                Text(food.category).opacity(0.5)
                Text(food.name)
                //                Text(restaurant.name)
                Text("SEK \(food.price.description)").font(.body)
            }
            Spacer()
            AsyncImage(url: pizzaURL,
                       content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 90)
            },
                       placeholder: {
                ProgressView()
            })
                .cornerRadius(10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        //.background(.red)
        .eraseToAnyView()
    }
}

//struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
//}
