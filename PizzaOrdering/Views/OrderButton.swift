//
//  OrderButton.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import SwiftUI

struct OrderButton: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresented: Bool = false
    @Binding var isTapped: Bool

    init(isTapped: Binding<Bool>) {
        _isTapped = isTapped
    }

    var body: some View {
        Button(action: {
            print("order")
            self.isPresented = true
            self.isTapped = true
        }) {
            HStack {
                if appState.quantity > 0 {
                    Image(systemName: "cart.fill").accentColor(.white)
                } else {
                    Image(systemName: "cart").accentColor(.white)
                }
                Spacer()
                Text("Order").foregroundColor(.white)
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
    }
}

//struct OrderButton_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderButton()
//    }
//}
