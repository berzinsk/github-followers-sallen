//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 13/02/2023.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
