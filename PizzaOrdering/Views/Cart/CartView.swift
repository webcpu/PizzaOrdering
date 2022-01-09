//
//  RestaurantView.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CoreLocation
import Combine

struct CartView: View {
    @EnvironmentObject var cartModel: CartModel
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
    
    var cartButton = Button(action: {print("cart")}) {
        Image(systemName: "cart")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Text(cartModel.restaurant.name)
                    ForEach(0..<cartModel.cart.items.count, id: \.self) { index in
                        let item = cartModel.cart.items[index]
                        LineItemRow(lineItem: item)
                            .frame(maxWidth: .infinity)
                    }
                    .onDelete(perform: delete)
                    HStack {
                        Text("Subtotal").fontWeight(.semibold)
                        Spacer()
                        Text("SEK \(cartModel.subtotal.description)").fontWeight(.semibold)
                    }
                }
                .listStyle(.grouped)
                .environment(\.editMode, self.$isEditMode)
                
                VStack {
                    Spacer()
                    NavigationLink(destination: CheckoutView(), isActive: $isLinkActive) {
                        OrderButton(isTapped: $isLinkActive)
                    }
                    .disabled(cartModel.cart.items.isEmpty)
                }
            }
            .navigationBarTitle("Shopping Cart")
            .navigationBarItems(leading: closeButton)
            .task {
                dump(cartModel.cart)
                dump(cartModel.subtotal)
//                if cartModel.cart.items.isEmpty {
//                    self.presentationMode.wrappedValue.dismiss()
//                }
            }
        }
    }
    //.navigationTitle("Restaurants Near Me" + location.description)
    //        .task {
    //            //            if self.cartModel.cart == nil {
    //            //               self.cartModel.cart = Cart(items: [], restuarantId: restaurantId)
    //            //            }
    //        }
    //       .edgesIgnoringSafeArea(.horizontal)
    //.colorMultiply(.white)
    //.eraseToAnyView()
    
    func delete(at offsets: IndexSet) {
        print("delete")
        cartModel.removeItem(atOffsets: offsets)
    }
}

//fileprivate struct BackButton: View {
//    var body: some View {
//        Button(action: {
//            print("order")
//            self.isPresented = true
//            self.isTapped = true
//            dump(cartModel.cart)
//            self.presentationMode.wrappedValue.dismiss()
//        })
//}

fileprivate struct LineItemRow: View {
    //@EnvironmentObject var cartModel: AppState
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    let lineItem: LineItem
    @State var restaurant: Restaurant?
    
    init(lineItem: LineItem) {
        self.lineItem = lineItem
        //self.restaurant = cartModel.restaurant
    }
    
    var pizzaURL: URL? {
        let pizzaURLString = "https://www.iliveitaly.it/wp-content/uploads/2019/01/Pizza-in-Italian-Food.png"
        return URL(string: pizzaURLString) }
    
    var body: some View {
        HStack {
            Text(String(lineItem.quantity))
            //Text(String(lineItem.price ?? 0))
            Spacer()
            Text("SEK \(lineItem.sum.description)").font(.body)
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
