//
//  Webservice.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badRequest
    case decodingError
}

class Webservice {
    
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func placeOrder(order: Order) async throws -> Order {
        
        guard let url = URL(string: Endpoint.placeOrder.path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
          throw NetworkError.badRequest
        }
        
        guard let newOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return newOrder
    }
    
    func getOrders() async throws -> [Order] {
        
        guard let url = URL(string: Endpoint.allOrders.path, relativeTo: baseURL)
        else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
          throw NetworkError.badRequest
        }
        
        guard let orders = try? JSONDecoder().decode([Order].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return orders
                
    }
    
    func deleteOrder(_ orderId: Int) async throws -> Order {
        
        guard let url = URL(string: Endpoint.deleteOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let deletedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return deletedOrder
    }
    
    func updateOrder(_ order: Order) async throws -> Order {
        
        guard let orderId = order.id else {
            throw NetworkError.badUrl
        }
        
        guard let url = URL(string: Endpoint.updateOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
          throw NetworkError.badRequest
        }
        
        guard let updatedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return updatedOrder
    }
}
