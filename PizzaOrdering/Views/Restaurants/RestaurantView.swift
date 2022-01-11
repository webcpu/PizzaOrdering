//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import CachedAsyncImage
import CocoaLumberjackSwift

struct RestaurantView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartViewModel: CartViewModel
    @State var restaurant: Restaurant
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @StateObject var viewModel: RestaurantViewModel
    
    var listedFoods: [Food] {
        viewModel.items
            .filter { $0.matches(viewModel.searchString)}
//            .sorted(by: {
//                if $0.category.localizedCompare($1.category) != .orderedSame {
//                    return $0.category.localizedCompare($1.category) == .orderedAscending
//                } else {
//                    return $0.name.localizedCompare($1.name) == .orderedAscending
//                }
//            })
    }
    
    init(restaurant: Restaurant) {
        self._restaurant = State(wrappedValue: restaurant)
        self._viewModel = StateObject(wrappedValue: RestaurantViewModel(restaurant))
    }
    
    var body: some View {
        ZStack {
            internalRestaurantView
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
    
    var internalRestaurantView: some View {
        List {
            ForEach(viewModel.items, id: \.id) { item in
                if !viewModel.restaurant.isDummy {
                    NavigationLink(destination: FoodView(restaurant: viewModel.restaurant, food: item)) {
                        FoodRow(restaurant: viewModel.restaurant, food: item)
                    }
                    .frame(maxWidth: .infinity)
                    .accessibility(addTraits: .isButton)
//                    .accessibility(identifier: "food" + String(index))
                    .accessibility(identifier: "food" + String(viewModel.items.firstIndex(of: item) ?? -1))

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
//            .searchable(text: $viewModel.searchString) {
//                ForEach(Array(viewModel.searchSuggestions.enumerated()), id: \.offset) { index, suggestion in
//                    Text(suggestion.name).searchCompletion(suggestion.name)
//                }
//            }
            .onChange(of: viewModel.searchString) { newValue in
                DDLogInfo(newValue)
            }
        }
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
            VStack(alignment: .leading) {
                Text(food.name).font(.headline)
                Spacer()
                Text("SEK \(food.price.description)")
                Spacer()
                Text(food.category).foregroundStyle(.secondary)
                Spacer()
                //                Text(restaurant.name)
            }
            .font(.subheadline)
            Spacer()
            Image(food.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 90)
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
