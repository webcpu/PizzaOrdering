//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import CachedAsyncImage

struct RestaurantView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartViewModel: CartViewModel
    @State var restaurant: Restaurant
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @StateObject var viewModel: RestaurantViewModel
    
    init(restaurant: Restaurant) {
        self._restaurant = State(wrappedValue: restaurant)
        self._viewModel = StateObject(wrappedValue: RestaurantViewModel(restaurant))
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    if !viewModel.restaurant.isDummy {
                        NavigationLink(destination: FoodView(restaurant: viewModel.restaurant, food: item)) {
                            FoodRow(restaurant: viewModel.restaurant, food: item)
                        }
                        .frame(maxWidth: .infinity)
                //        .listRowSeparator(.hidden)
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
//                .listStyle(.grouped)
                .listStyle(.insetGrouped)
                //            .listStyle(GroupedListStyle())
            }
            VStack {
                Spacer()
                CartButton()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {Image(systemName: "arrow.backward")})
        //        .background(.clear)
        //.navigationTitle("Restaurants Near Me" + location.description)
        //            .navigationTitle(viewModel.location.description)
        .navigationTitle(viewModel.restaurant.name)
        .task {
            self.cartViewModel.restaurant = viewModel.restaurant
            if self.cartViewModel.cart.isDummy {
                self.cartViewModel.cart = Cart(items: [], restaurantId: restaurant.id)
            }
            await viewModel.update()
            self.cartViewModel.restaurant = viewModel.restaurant
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
                Text(food.category).opacity(0.5)
                Spacer()
                Text(food.name)
                Spacer()
                //                Text(restaurant.name)
                Text("SEK \(food.price.description)").font(.body)
            }
            Spacer()
            CachedAsyncImage(url: pizzaURL,
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
        //.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .listRowBackground(
            Color(.systemGray3).edgesIgnoringSafeArea([.leading, .trailing])
        )
        //        .onAppear {
        //            UITableView.appearance().backgroundColor = .clear
        //            //            UITableView.back
        //        }
        //.background(.red)
        .eraseToAnyView()
    }
}

//struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
//}
