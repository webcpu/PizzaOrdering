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
    @State private var items: KeyValuePairs<String, String> = [:]
    
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
            return AnyView(SummaryView(orderSummary))
        case .failure(let error):
            return AnyView(Text("Unknown Error"))
        case nil:
            return AnyView(ProgressView().onAppear(perform: load))
            //.navigationBarItems(leading: backButton())
        }
    }
}

struct SummaryView: View {
    @State var items: KeyValuePairs<String, String>
    
    init(_ summary: OrderSummary) {
        self.items = SummaryView.getSummaryItems(summary)
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach (0..<self.items.count, id:\.self) { index in
                    OrderSummaryRow(self.items[index].0, items[index].1)
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

extension SummaryView {
    static func getSummaryItems(_ orderSummary: OrderSummary) -> KeyValuePairs<String, String> {
        let items: KeyValuePairs<String, String> = [
            "Order ID": String(orderSummary.orderID),
            "Total Price": ("SEK " + orderSummary.totalPrice.description),
            "Ordered At": orderSummary.orderedAt,
            "Estimated Delivery": orderSummary.estimatedDelivery,
            "Status": String(orderSummary.status.capitalized)]
        return items
    }
}

struct OrderSummaryRow: View {
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
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
