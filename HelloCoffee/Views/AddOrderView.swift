//
//  AddOrderView.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 12/02/26.
//


import SwiftUI

struct AddOrderErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
}

struct AddOrderView: View {
    
    var order: Order? = nil
    
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors: AddOrderErrors = AddOrderErrors()
    
    @EnvironmentObject private var model: CoffeeModel
    
    @Environment(\.dismiss) private var dismiss
    
    private func validate() -> Bool {
        errors = AddOrderErrors()
        
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty!"
        }
        
        if price.isEmpty {
            errors.price = "Price cannot be empty!"
        } else if !price.isNumeric {
            errors.price = "Price needs to be a number!"
        } else if price.isLessThan(1) {
            errors.price = "Price needs to be more than 0"
        }
        
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.price.isEmpty
    }
    
    private func placeOrder(_ newOrder: Order) async {
        do {
            try await model.placeOrder(newOrder)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func updateOrder(_ editOrder: Order) async {
        do {
            try await model.updateOrder(editOrder)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func populateExistingOrder() {
        if let order = order {
            name = order.name
            coffeeName = order.coffeeName
            price = String(order.total)
            coffeeSize = order.size
        }
    }
    
    private func saveOrUpdate() async {
        if let order {
            var editOrder = order
            editOrder.name = name
            editOrder.coffeeName = coffeeName
            editOrder.size = coffeeSize
            editOrder.total = Double(price) ?? 0.0
            
            await updateOrder(editOrder)
        } else {
            let newOrder = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
            await placeOrder(newOrder)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("name")
                Text(errors.name)
                    .visible(errors.name.isNotEmpty)
                    .font(.caption)
                
                TextField("Coffee name", text: $coffeeName)
                    .accessibilityIdentifier("coffeeName")
                Text(errors.coffeeName)
                    .visible(errors.coffeeName.isNotEmpty)
                    .font(.caption)
                
                TextField("Price", text: $price)
                    .accessibilityIdentifier("price")
                Text(errors.price)
                    .visible(errors.price.isNotEmpty)
                    .font(.caption)
                
                Picker("Select size", selection: $coffeeSize) {
                    ForEach(CoffeeSize.allCases, id: \.rawValue) { size in
                        Text(size.rawValue).tag(size)
                    }
                }.pickerStyle(.segmented)
                
                Button(order != nil ? "Update order" : "Place order") {
                    
                    if validate() {
                        Task {
                            await saveOrUpdate()
                        }
                    }
                    
                }.accessibilityIdentifier("placeOrderButton")
                    .centerHorizontally()
            }.navigationTitle(order != nil ? "Edit Order" : "Add Order" )
                .onAppear {
                    populateExistingOrder()
                }
                
        }
    }
}

#Preview {
    AddOrderView(order: nil)
}
