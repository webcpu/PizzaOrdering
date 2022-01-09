//
//  OrderDetailView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import SwiftUI
import Alamofire

enum OrderDetailError: Error {
    case UnknownError
}

struct OrderDetailView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @Binding private var order: Order
    @Binding private var restaurant: Restaurant
    
    @State private var fields: KeyValuePairs<String, String> = [:]
    
    init(_ theOrder: Binding<Order>, _ theRestaurant: Binding<Restaurant>) {
        self._order = theOrder
        self._restaurant = theRestaurant
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                restaurantView
                orderDetailView
            }
        }
        .navigationBarTitle("Order #\(String(order.orderID))")
        .task {
            self.fields = OrderDetailView.getFields(order)
        }
        .eraseToAnyView()
    }
    
    var restaurantView: some View {
        VStack {
            NavigationLink(destination: RestaurantView(restaurant: restaurant)) {
                ZStack {
                    Image("r1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity, height: 150)
                        .clipped()
                        .cornerRadius(5)
                    HStack {
                        Spacer()
                        Text("View shop")
                            .font(.footnote)
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: 80, height: 30)
                            .background(.gray)
                            .opacity(0.75)
                            .cornerRadius(5)
                            .padding(.top, 100)
                            .padding(.trailing, 20)
                    }
                }
            }
            Text(restaurant.name).font(.largeTitle)
        }
    }
    
    var orderDetailView: some View {
        List {
            Section {
                HStack {
                    Text(order.orderedAt.shortDateString)
                    Spacer()
                    Text(order.status)
                }
            }
            
            Section(header: Text("Your order")) {
                ForEach(0..<order.items.count, id:\.self) {index in
                    LineItemRow(order.items[index], restaurant)
                }
            }
            
            Text("Total: SEK " + order.totalPrice.description)
            Section(header: Text("Detail")) {
                ForEach(0..<self.fields.count, id:\.self) { index in
                    OrderDetailRow(self.fields[index].0, fields[index].1)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

extension OrderDetailView {
    static func getFields(_ order: Order) -> KeyValuePairs<String, String> {
        let fields: KeyValuePairs<String, String> = [
            "Order ID": String(order.orderID),
            //            "Total Price": ("SEK " + order.totalPrice.description),
            "Ordered At": order.orderedAt.longDateString,
            "Estimated Delivery": order.estimatedDelivery.longDateString,
            //            "Status": String(order.status.capitalized)
        ]
        return fields
    }
}

fileprivate struct LineItemRow: View {
    @State var food: Food = Food(id: -1, category: "", name: "", topping: [], price: 0, rank: nil)
    let restaurant: Restaurant
    let lineItem: LineItem
    
    init(_ theLineItem: LineItem, _ restaurant: Restaurant) {
        self.lineItem = theLineItem
        self.restaurant = restaurant
    }
    
    var body: some View {
        HStack {
            Text(String(lineItem.quantity))
            Spacer()
            Text(food.name)
        }
        .font(.callout)
        .task {
            let items = await BackendAPI.getMenu(restaurant.id, "Pizza", "rank")
            if let food = items.filter({$0.id == lineItem.menuItemId}).first {
                self.food = food
                dump(food)
            }
        }
    }
}

struct OrderDetailRow: View {
    let key: String
    let value: String
    
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }.font(.callout)
    }
}

struct _OrderDetailView: View {
    @State var fields: KeyValuePairs<String, String>
    
    init(_ summary: OrderSummary) {
        self.fields = SummaryView.getSummaryItems(summary)
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach (0..<self.fields.count, id:\.self) { index in
                    OrderDetailRow(self.fields[index].0, fields[index].1)
                }
            }
            .listStyle(.grouped)
            
            VStack {
                Spacer()
                Text("Hi")
            }
        }
        .navigationBarTitle("Order Summary")
    }
}

extension _OrderDetailView {
    static func getSummaryItems(_ orderSummary: OrderSummary) -> KeyValuePairs<String, String> {
        let items: KeyValuePairs<String, String> = [
            "Order ID": String(orderSummary.orderID),
            "Total Price": ("SEK " + orderSummary.totalPrice.description),
            "Ordered At": orderSummary.orderedAt.longDateString,
            "Estimated Delivery": orderSummary.estimatedDelivery.longDateString,
            "Status": String(orderSummary.status.capitalized)]
        return items
    }
}
