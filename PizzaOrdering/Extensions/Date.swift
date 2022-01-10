//
//  Date.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-08.
//

import Foundation

extension Date {
    //"2016-04-14T10:44:00+0000"
    static func fromISODateString(_ isoDateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let date = dateFormatter.date(from: isoDateString)
        return date
    }

    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }

    var longDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.iso8601withFractionalSeconds.string(from: $0))
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

//extension Formatter {
//    static let iso8601withFractionalSeconds: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//        return formatter
//    }()
//}
