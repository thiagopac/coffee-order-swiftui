//
//  OrderDetailView.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 17/02/26.
//


import SwiftUI

struct OrderDetailView: View {
    
    let orderId: Int
    @EnvironmentObject private var model: CoffeeModel
    @State private var isPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    private func deleteOrder(_ orderId: Int?) async throws {
        
        guard let orderId = orderId else { return }
        do {
            try await model.deleteOrder(orderId)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                    Text(order.name)
                        .foregroundStyle(.blue)
                        .fontWeight(.bold)
                        .accessibilityIdentifier("nameText")
                    Text(order.size.rawValue)
                        .opacity(0.5)
                        .accessibilityIdentifier("coffeeSizeText")
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                        .accessibilityIdentifier("coffeePriceText")
                    
                    HStack {
                        Spacer()
                        Button("Delete order", role: .destructive) {
                            
                            Task {
                                try await deleteOrder(order.id)
                            }
                            
                        }.accessibilityIdentifier("deleteOrderButton")
                        Spacer()
                        Button("Edit order") {
                            isPresented = true
                        }.accessibilityIdentifier("editOrderButton")
                        Spacer()
                    }
                }.sheet(isPresented: $isPresented) {
                    AddOrderView(order: order)
                }
                
            }
            
            Spacer()
            
        }.padding()
    }
}

#Preview {
    var configuration = Configuration()
    OrderDetailView(orderId: 1)
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: configuration.environment.baseURL)))
}
