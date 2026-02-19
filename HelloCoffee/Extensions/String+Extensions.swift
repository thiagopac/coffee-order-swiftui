//
//  String+Extensions.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 13/02/26.
//


import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func isLessThan(_ number: Double) -> Bool {
        if !self.isNumeric {
            return false
        }
        
        guard let value = Double(self) else { return false }
        return value < number
    }
}
