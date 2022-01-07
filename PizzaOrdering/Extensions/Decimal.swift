//
//  Decimal.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-07.
//

import Foundation

extension Decimal: CustomStringConvertible {
    var description: String {
        let number = NSDecimalNumber(decimal: self)
        return String(format: "%.2f", number.doubleValue)
    }
}
