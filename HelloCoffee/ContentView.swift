//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//


import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false

    private func populateOrders() async {
        
        do {
            try await model.populateOrders()
        } catch {
            print(error)
        }
    }
    
    private func deleteOrder(_ indexSet: IndexSet) {
        
        indexSet.forEach { index in
            let order = model.orders[index]
            guard let orderId = order.id else {
                return
            }
            
            Task {
                do {
                    try await model.deleteOrder(orderId)
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    @EnvironmentObject private var model: CoffeeModel
    
    
    private func refreshScreen() async {
        await populateOrders()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!").accessibilityIdentifier("noOrdersText")
                } else {
                    List {
                        ForEach(model.orders) { order in
                            NavigationLink(value: order.id) {
                                OrderCellView(order: order)
                            }
                        }.onDelete(perform: deleteOrder)
                    }.accessibilityIdentifier("orderList")
                }
            }
            .navigationDestination(for: Int.self, destination: { orderId in
                OrderDetailView(orderId: orderId)
            })
            .task {
                await populateOrders()
            }
            .sheet(isPresented: $isPresented, content: {
                AddOrderView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add new order") {
                        isPresented = true
                    }.accessibilityIdentifier("addNewOrderButton")
                }
            }.refreshable {
                Task {
                    await refreshScreen()
                }
            }
        }
    }
}

#Preview {
    var configuration = Configuration()
    ContentView()
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: configuration.environment.baseURL)))
}


