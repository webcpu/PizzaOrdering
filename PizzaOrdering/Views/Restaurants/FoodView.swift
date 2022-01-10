//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import CachedAsyncImage

struct FoodView: View {
    var restaurant: Restaurant
    @State var food: Food
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
//    @StateObject var viewModel: FoodViewModel

    init(restaurant: Restaurant, food: Food) {
        self.restaurant = restaurant
        self.food = food
        //        self._viewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantId))
    }

    var body: some View {
        ZStack {
            List {
                Section(food.category) {
                    Text(food.name).font(.title).fontWeight(.semibold)
                }
                if food.topping != nil && food.topping!.count > 0 {
                    Section("Topping") {
                        ForEach(food.topping ?? [], id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .listRowSeparator(.hidden)

                        }
                    }
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
            //        .background(.clear)
            //.navigationTitle("Restaurants Near Me" + location.description)
            //            .navigationTitle(viewModel.location.description)
            //        .navigationTitle(food.name)

            VStack {
                Spacer()
                AddItemButton(restaurant: restaurant, food: food)
                //                Image(systemName: "square.fill")
                //                    .resizable()
                //                    .frame(width: 24.0, height: 18.0)
                //                    .foregroundColor(.pink)
                //                Text("\(10)").foregroundColor(.white)
            }
        }
        .task {
            //        await viewModel.update()
        }
        .edgesIgnoringSafeArea(.horizontal)
        .eraseToAnyView()
    }
}

struct FoodOptionRow: View {
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    let food: Food
    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(food.category).opacity(0.5)
                Text(food.name)
                //                Text(restaurant.name)
                Text("SEK \(food.price.description)").font(.body)
            }//.foregroundColor(Color.white)
            Spacer()
            CachedAsyncImage(url: pizzaURL,
                       content: { image in
                //                                GeometryReader { geo in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 90)
                //                    .clipped()
                //                              }
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
