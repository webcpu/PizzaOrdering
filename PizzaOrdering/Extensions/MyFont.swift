//
//  MyFont.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation
import SwiftUI

struct MyFont: ViewModifier {

    @Environment(\.sizeCategory) var sizeCategory

    public enum TextStyle {
        case title
        case body
        case price
    }

    var textStyle: TextStyle

    func body(content: Content) -> some View {
        let font = UIFont.systemFont(ofSize: 18)
        return content.font(Font(uiFont: font))
    }

    private var fontName: String {
        switch textStyle {
        case .title:
            return "TitleFont-Bold"
        case .body:
            return "MyCustomFont-Regular"
        case .price:
            return "DisplayText-Semibold"
        }
    }

    private var size: CGFloat {
        switch textStyle {
        case .title:
            return 26
        case .body:
            return 16
        case .price:
            return 14
        }
    }
}

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
