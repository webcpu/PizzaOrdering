//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import Combine
import CocoaLumberjackSwift

enum FoodError: Error {
    case UnknownError
}

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif

    @State var isPresented: Bool = false
    @State var isLinkActive = false
    @State var isEditMode: EditMode = .inactive

    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
        }
    }

    var cartButton = Button(action: {DDLogInfo("cart")}) {
        Image(systemName: "cart")
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Text(cartViewModel.restaurant.name)
                    ForEach(0..<cartViewModel.cart.items.count, id: \.self) { index in
                        let item = cartViewModel.cart.items[index]
                        LineItemRow(lineItem: item)
                            .frame(maxWidth: .infinity)
                    }
                    .onDelete(perform: delete)
                    HStack {
                        Text("Subtotal").fontWeight(.semibold)
                        Spacer()
                        Text("SEK \(cartViewModel.subtotal.description)").fontWeight(.semibold)
                    }
                }
                .listStyle(.grouped)
                .environment(\.editMode, self.$isEditMode)

                VStack {
                    Spacer()
                    NavigationLink(destination: CheckoutView(), isActive: $isLinkActive) {
                        OrderButton(isTapped: $isLinkActive)
                    }
                    .disabled(cartViewModel.cart.items.isEmpty)
                }
            }
            .navigationBarTitle("Shopping Cart")
            .navigationBarItems(leading: closeButton)
            .task {
                dump(cartViewModel.cart)
                dump(cartViewModel.subtotal)
                if cartViewModel.cart.items.isEmpty {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    //.navigationTitle("Restaurants Near Me" + location.description)
    //        .task {
    //            //            if self.cartViewModel.cart == nil {
    //            //               self.cartViewModel.cart = Cart(items: [], restuarantId: restaurantId)
    //            //            }
    //        }
    //       .edgesIgnoringSafeArea(.horizontal)
    //.colorMultiply(.white)
    //.eraseToAnyView()

    func delete(at offsets: IndexSet) {
        DDLogInfo("delete")
        cartViewModel.removeItem(atOffsets: offsets)
    }
}

private struct LineItemRow: View {
    @EnvironmentObject var cartViewModel: CartViewModel
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    let lineItem: LineItem
    @State private var result: Result<Food, Error>?

    init(lineItem: LineItem) {
        self.lineItem = lineItem
//        self.restaurant = self.cartViewModel.restaurant
    }

    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }

    var body: some View {
        switch result {
        case .success(let food):
            return AnyView(InternalLineItemRow(lineItem, food))
        case .failure(let eror):
            return AnyView(InternalLineItemRow(lineItem, Food.dummyFood))
        case nil:
            return AnyView(ProgressView().onAppear(perform: load))
        }
    }

    func load() {
        Task {
            let items = await BackendAPI.getMenu(cartViewModel.restaurant.id, "Pizza", "rank")
            if let food = items.filter({$0.id == lineItem.menuItemId}).first {
                result = .success(food)
            } else {
                result = .failure(FoodError.UnknownError)
            }
        }
    }
}

struct InternalLineItemRow: View {
    var lineItem: LineItem
    var food: Food

    init(_ lineItem: LineItem, _ food: Food) {
        self.lineItem = lineItem
        self.food = food
    }

    var body: some View {
        HStack {
            Text(String(lineItem.quantity)).padding(.trailing, 10)
            HStack {
                Text(food.name)
                Spacer()
                Text("SEK \(lineItem.sum.description)").font(.body)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .eraseToAnyView()
    }
}

//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
//}
