//
//  Date+.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
