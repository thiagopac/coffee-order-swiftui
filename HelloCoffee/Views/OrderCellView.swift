//
//  OrderCellView.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//


import SwiftUI

struct OrderCellView: View {
    
    let order: Order
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(order.name)
                    .accessibilityIdentifier("orderNameText")
                    .bold()
                Text("\(order.coffeeName) (\(order.size.rawValue))")
                    .accessibilityIdentifier("coffeeNameAndSizeText")
                    .opacity(0.5)
            }
            Spacer()
            Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                .accessibilityIdentifier("coffeePriceText")
        }
    }
}

#Preview {
    OrderCellView(order: Order(
        id: 1,
        name: "Thiago",
        coffeeName: "Cappuccino",
        total: 12.50,
        size: .medium
    ))
}
