//
//  DateExtension.swift
//  ExpenseTrackerApplication
//
//  Created by Kamil Kakar on 27/03/2025.
//

import Foundation

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
