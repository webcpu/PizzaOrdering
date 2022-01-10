//
//  CartButton.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI
import CocoaLumberjackSwift

struct CartButton: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresentedCartView: Bool = false

    fileprivate func cartImage() -> some View {
        if cartViewModel.quantity > 0 {
            return Image(systemName: "cart.fill").accentColor(.white)
        } else {
            return Image(systemName: "cart").accentColor(.white)
        }
    }

    var body: some View {
        Button(action: {
            DDLogInfo("view cart")
            //self.presentationMode.wrappedValue.dismiss()
            self.isPresentedCartView = true
        }) {
            HStack {
                cartImage()
                Spacer()
                Text("View cart (\(cartViewModel.quantity))").foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 44)
        .background(Color.pink)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .fullScreenCover(isPresented: $isPresentedCartView) {
            if !cartViewModel.restaurant.isDummy {
                CartView()
            }
        }
        .opacity(cartViewModel.quantity > 0 ? 1 : 0)
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton()
    }
}
