//
//  NumberFormatter+Extensions.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//


import Foundation

extension NumberFormatter {
    
    static var currency: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
}
