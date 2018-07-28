//
//  CustomDateFormatter.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/28/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import Foundation

var iso8601dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    return dateFormatter
}()

var iso8601dateFormatterWithoutMilliseconds: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter
}()

func customDateFormatter(_ decoder: Decoder) throws -> Date {
    let dateString = try decoder.singleValueContainer().decode(String.self)
    switch dateString.count {
    case 20..<Int.max:
        return iso8601dateFormatter.date(from: dateString)!
    case 19:
        return iso8601dateFormatterWithoutMilliseconds.date(from: dateString)!
    default:
        let dateKey = decoder.codingPath.last
        fatalError("Unexpected date coding key: \(String(describing: dateKey))")
    }
}
