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
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var restaurantId: Int
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
    
    @State var isPresented: Bool = false
    @State var isLinkActive = false
    @State var isEditMode: EditMode = .inactive

    init(restaurantId: Int) {
        self.restaurantId = restaurantId
    }
    
    func backButton() -> some View {
        Button(action: {
            print("person")
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
                    ForEach(0..<(appState.cart?.items.count ?? 0), id: \.self) { index in
                        let item = appState.cart!.items[index]
                        //                    if self.appState.restaurant != nil {
                        LineItemRow(lineItem: item)
                            .frame(maxWidth: .infinity)
                            //.listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                    HStack {
                        Text("Subtotal").fontWeight(.semibold)
                        Spacer()
                        Text("SEK \(appState.subtotal.description)").fontWeight(.semibold)
                    }
                }
                .listStyle(.grouped)
                .environment(\.editMode, self.$isEditMode)
                
                VStack {
                    Spacer()
                    NavigationLink(destination: CheckoutView(), isActive: $isLinkActive) {
                        OrderButton(isTapped: $isLinkActive)
                    }
                    .disabled((appState.cart?.items.count ?? 0) == 0)
                }
            }
            .navigationBarTitle("Shopping Cart")
            .navigationBarItems(leading: backButton())
        }
    }
    //.navigationTitle("Restaurants Near Me" + location.description)
    //        .task {
    //            //            if self.appState.cart == nil {
    //            //               self.appState.cart = Cart(items: [], restuarantId: restaurantId)
    //            //            }
    //        }
    //       .edgesIgnoringSafeArea(.horizontal)
    //.colorMultiply(.white)
    //.eraseToAnyView()
    
    func delete(at offsets: IndexSet) {
        print("delete")
        appState.removeItem(atOffsets: offsets)
    }
}

//fileprivate struct BackButton: View {
//    var body: some View {
//        Button(action: {
//            print("order")
//            self.isPresented = true
//            self.isTapped = true
//            dump(appState.cart)
//            self.presentationMode.wrappedValue.dismiss()
//        })
//}

struct LineItemRow: View {
    //@EnvironmentObject var appState: AppState
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
    let lineItem: LineItem
    @State var restaurant: Restaurant?
    
    init(lineItem: LineItem) {
        self.lineItem = lineItem
        //self.restaurant = appState.restaurant
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
