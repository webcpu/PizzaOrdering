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
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var result: Result<OrderSummary, Error>?
    @State private var items: KeyValuePairs<String, String> = [:]

    func load() {
        Task {
            if let orderSummary = await cartViewModel.createOrder() {
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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var items: KeyValuePairs<String, String>

    init(_ summary: OrderSummary) {
        self._items = State(wrappedValue: SummaryView.getSummaryItems(summary))
    }

    var body: some View {
        ZStack {
            List {
                ForEach(0..<self.items.count, id: \.self) { index in
                    OrderSummaryRow(self.items[index].0, items[index].1)
                }
            }
            .listStyle(.grouped)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {Image(systemName: "arrow.backward")}, trailing: Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitle("Order Summary")
    }
}

extension SummaryView {
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
            Text(value).accessibility(identifier: "summary." + key)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
