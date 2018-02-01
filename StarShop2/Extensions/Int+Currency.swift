//
//  Int+Currency.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 29/01/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import Foundation

extension Int {
    
    var asCurrencyFormat: String {
        let realValue = Double(self) / 100
        return self.format(realValue: realValue)
    }
    
    private func format(realValue: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        formatter.currencySymbol = "R$"
        formatter.currencyDecimalSeparator = ","
        formatter.currencyGroupingSeparator = "."
        formatter.numberStyle = NumberFormatter.Style.currency
        
        return formatter.string(from: NSNumber(value: realValue))!
    }
    
}
