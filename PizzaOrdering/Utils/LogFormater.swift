//
//  LogFormater.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-09.
//

import Foundation
import CocoaLumberjackSwift
   // .DDDispatchQueueLogFormatter

class LogFormatter: DDDispatchQueueLogFormatter {
    let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.dateFormat = "HH:mm:ss:SSS"
        //dateFormatter.dateFormat = "HH:mm"
        
        super.init()
    }
    override func format(message: DDLogMessage) -> String {
        let dateAndTime = dateFormatter.string(from: message.timestamp)
        return "\(dateAndTime) [\(message.fileName) \(message.function!):\(message.line)] \(message.message)"
    }
}
