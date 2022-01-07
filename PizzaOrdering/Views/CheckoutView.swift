//
//  CheckoutView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import SwiftUI

enum OrderError: Error {
    case UnknownError
}

struct CheckoutView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var result: Result<OrderSummary, Error>?
    
    func load() {
        Task {
            if let orderSummary = await appState.createOrder() {
                result = .success(orderSummary)
            } else {
                result = .failure(OrderError.UnknownError)
            }
        }
    }
    
    var body: some View {
        switch result {
        case .success(let orderSummary):
            ZStack {
                List {
                    HStack {
                        Text("Order ID")
                        Spacer()
                        Text(String(orderSummary.orderID))
                    }
                    HStack {
                        Text("Total Price")
                        Spacer()
                        Text("SEK " + orderSummary.totalPrice.description)
                    }
                    HStack {
                        Text("Ordered At")
                        Spacer()
                        Text(orderSummary.orderedAt)
                    }
                    HStack {
                        Text("Estimated Delivery")
                        Spacer()
                        Text(orderSummary.estimatedDelivery)
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(String(orderSummary.status.capitalized))
                    }
                }
                .listStyle(.grouped)
                
                VStack {
                    Spacer()
                    Text("Hi")
                    //OrderButton(isTapped: $isLinkActive)
                }
            }
            .navigationBarTitle("Order Summary")
        case .failure(let error):
            Text("Unknown Error")
        case nil:
            ProgressView().onAppear(perform: load)
            //.navigationBarItems(leading: backButton())
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
