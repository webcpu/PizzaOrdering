//
//  CartButton.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI

struct CartButton: View {
    @EnvironmentObject var cartModel: CartModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresentedCartView: Bool = false

    fileprivate func cartImage() -> some View {
        if cartModel.quantity > 0 {
            return Image(systemName: "cart.fill").accentColor(.white)
        } else {
            return Image(systemName: "cart").accentColor(.white)
        }
    }
    
    var body: some View {
        Button(action: {
            print("view cart")
            //self.presentationMode.wrappedValue.dismiss()
            self.isPresentedCartView = true
        }) {
            HStack {
                cartImage()
                Spacer()
                Text("View cart (\(cartModel.quantity))").foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 44)
        .background(Color.pink)
        .padding(.horizontal,  20)
        .padding(.vertical,  5)
        .fullScreenCover(isPresented: $isPresentedCartView) {
            if !cartModel.restaurant.isDummy {
                CartView()
            }
        }
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton()
    }
}
