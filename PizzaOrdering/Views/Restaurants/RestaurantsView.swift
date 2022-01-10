//
//  RestaurantsView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import CachedAsyncImage

struct RestaurantsView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @StateObject var viewModel = RestaurantsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                internalRestaurantsView
                cartButton
            }
            .navigationTitle("Restaurants")
        }
        .eraseToAnyView()
    }

    var internalRestaurantsView: some View {
        List(viewModel.items, id: \.id) { restaurant in
            NavigationLink(destination: RestaurantView(restaurant: restaurant)) {
                RestaurantRow(location: viewModel.location, restaurant: restaurant)
            }
            .listRowSeparator(.hidden)
            .accessibility(addTraits: .isButton)
            .accessibility(identifier: "restaurant" + String(viewModel.items.firstIndex(of: restaurant) ?? 0))
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .listStyle(GroupedListStyle())
    }

    var cartButton: some View {
        if !self.cartViewModel.cart.isDummy && !self.cartViewModel.cart.items.isEmpty {
            return AnyView(VStack {
                Spacer()
                CartButton()})
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct RestaurantRow: View {
    var location: CLLocation
    let restaurant: Restaurant
    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }

    var body: some View {
        VStack {
            restaurantImage
            restaurantInfo
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }

    var restaurantImage: some View {
        CachedAsyncImage(url: pizzaURL,
                         content: { image in
            image.resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 150)
                .clipped()
        },
                         placeholder: {
            ProgressView()
        })
            .cornerRadius(10)
    }

    var restaurantInfo: some View {
        HStack {
            Text(restaurant.name).font(.headline)
            Spacer()
            Text(String(format: "%.1f km", restaurant.distanceInKM(from: location)))
        }
        .font(.subheadline)
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
    }
}
