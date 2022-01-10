//
//  Orders.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import SwiftUI

enum OrdersError: Error {
    case UnknownError
}

let mockOrderIds = [1234410, 1234411, 1234412]

struct OrdersView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var result: Result<[Int], Error>?
    @State private var orderIds: [Int] = []

    func load() {
        Task {
            self.result = .success(mockOrderIds)
        }
    }

    var body: some View {
        switch result {
        case .success(let items):
            return AnyView(InternalOrdersView(items).eraseToAnyView())
        case .failure(let error):
            return AnyView(Text("Unknown Error"))
        case nil:
            return AnyView(ProgressView().onAppear(perform: load))
            //.navigationBarItems(leading: backButton())
        }
    }
}

struct InternalOrdersView: View {
    @State var orderIds: [Int]
    @State var order: Order = Order(orderID: 0, totalPrice: 0, orderedAt: Date.distantPast, estimatedDelivery: Date.distantPast, status: "", items: [], restaurantId: 0)
    @State var restaurant: Restaurant = .dummyRestaurant

    init(_ ids: [Int]) {
        _orderIds = State(wrappedValue: ids)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header:
                                Text("Current Orders").font(.title3).fontWeight(.medium)
                    ) {
                        ForEach(0..<self.orderIds.count, id: \.self) { index in
                            NavigationLink(destination: OrderDetailView($order, $restaurant)) {
                                OrderRow(self.orderIds[index], $order, $restaurant)
                            }
                            .accessibility(addTraits: .isButton)
                            .accessibility(identifier: "order\(index)")
                        }
                    }
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .navigationBarTitle("Your Orders", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
        //.ignoresSafeArea(.all)
        
        .onAppear(perform: {
            // UITableView.appearance().backgroundColor = .systemBackground
        })
    }
}

struct OrderRow: View {
    @State var orderId: Int
    @Binding var order: Order
    @Binding var restaurant: Restaurant
    @State private var result: Result<Order, Error>?
    
    init(_ id: Int, _ order: Binding<Order>, _ restaurant: Binding<Restaurant>) {
        _orderId = State(wrappedValue: id)
        self._order = order
        self._restaurant = restaurant
    }
    
    var body: some View {
        switch result {
        case .success(let order):
            self.order = order
            return AnyView(internalOrderRow)
        case .failure(let error):
            return AnyView(Text("Unknown Error"))
        case nil:
            return AnyView(ProgressView().onAppear(perform: load))
            //.navigationBarItems(leading: backButton())
        }
        //        .task {
        //            order = await BackendAPI.getOrder(orderId)
        //        }
    }
    
    func load() {
        Task {
            if let order = await BackendAPI.getOrder(orderId) {
                result = .success(order)
                self.order = order
                let restaurant = await BackendAPI.getRestaurant(order.restaurantId)
                self.restaurant = restaurant
            } else {
                result = .failure(OrderError.UnknownError)
            }
        }
    }
    
    var internalOrderRow: some View {
        HStack {
            Image("r1").resizable().frame(width: 60, height: 45)
            VStack {
                HStack {
                    Text(String(restaurant.name)).font(.callout).fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    Text("items: " + String(order.quantity))
                        .fontWeight(.thin)
                    Text(" ")
                    Text("SEK " + order.totalPrice.description)
                        .fontWeight(.thin)
                    Spacer()
                }
                .font(.footnote)
                
                HStack {
                    Text(order.orderedAt.shortDateString).fontWeight(.thin)
                    Text(" ")
                    Text(order.status).fontWeight(.thin)
                    Spacer()
                }
                .font(.footnote)
                
            }
            Spacer()
            Text(String(orderId)).fontWeight(.thin).font(.footnote)
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
