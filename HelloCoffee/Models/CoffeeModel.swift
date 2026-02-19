//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//


import Foundation

@MainActor
class CoffeeModel: ObservableObject {
    
    let webservice: Webservice
    
    @Published private(set) var orders: [Order] = []
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func orderById(_ id: Int) -> Order? {
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        return orders[index]
    }
    
    func populateOrders() async throws -> Void {
        orders = try await webservice.getOrders()
    }
    
    func placeOrder(_ order: Order) async throws -> Void {
        let createdOrder = try await webservice.placeOrder(order: order)
        orders.append(createdOrder)
    }
    
    func deleteOrder(_ orderId: Int) async throws -> Void {
        let deletedOrder = try await webservice.deleteOrder(orderId)
        orders = orders.filter { $0.id != deletedOrder.id }
    }
    
    func updateOrder(_ order: Order) async throws -> Void {
        let updatedOrder = try await webservice.updateOrder(order)
        guard let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) else {
            throw CoffeeOrderError.invalidOrderId
        }
        
        orders[index] = updatedOrder
    }
}
