//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 19.11.21.
//

import Foundation



extension Date {
    func convertToMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

