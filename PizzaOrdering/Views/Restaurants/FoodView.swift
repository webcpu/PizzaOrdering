//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import CachedAsyncImage

fileprivate var pizzaURL: URL? {
    let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
    return URL(string: pizzaURLString)
}

struct FoodView: View {
    var restaurant: Restaurant
    @State var food: Food
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
//    @StateObject var viewModel: FoodViewModel

    init(restaurant: Restaurant, food: Food) {
        self.restaurant = restaurant
        self._food = State(wrappedValue: food)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                HStack {
                    Text(food.name).font(.largeTitle).bold()
                    Spacer()
                }
                Image(food.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                HStack {
                    Text("Category").font(.title).bold().foregroundStyle(.secondary)
                    Spacer()
                }
                HStack {
                    Text(food.category)
                    Spacer()
                }
                topping
                Spacer()
            }
            .padding(.horizontal, 20)
            VStack {
                Spacer()
                AddItemButton(restaurant: restaurant, food: food)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            //        await viewModel.update()
        }
        //.edgesIgnoringSafeArea(.horizontal)
        .eraseToAnyView()
    }
    
    var topping: some View {
        if food.topping != nil && !food.topping!.isEmpty {
            return AnyView(VStack(alignment: .leading, spacing: 0) {
                Text("Topping").font(.title).bold()
                    .foregroundStyle(.secondary)
                
                LazyVGrid(columns: [GridItem(.flexible(minimum: 25))]) {
                    ForEach(food.topping ?? [], id: \.self) { item in
                        HStack {
                            Image(systemName: "checkmark")
                            Text(item)
                            Spacer()
                        }.padding(.vertical, 5)
                        
                    }
                }
            }
            )
        } else {
            return AnyView(EmptyView())
        }
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
