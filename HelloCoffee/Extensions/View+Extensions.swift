//
//  View+Extensions.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 13/02/26.
//


import Foundation
import SwiftUI

extension View {
    
    func centerHorizontally() -> some View {
        HStack{
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder
    func visible(_ value: Bool) -> some View {
        switch value {
            case true:
                self
            case false:
                EmptyView()
        }
    }
    
}
