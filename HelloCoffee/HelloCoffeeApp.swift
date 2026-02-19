//
//  HelloCoffeeApp.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 11/02/26.
//


import SwiftUI

@main
struct HelloCoffeeApp: App {
    
    @StateObject private var model: CoffeeModel
    
    init() {
        var configuration = Configuration()
        let webservice = Webservice(baseURL: configuration.environment.baseURL)
        _model = StateObject(wrappedValue: CoffeeModel(webservice: webservice))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
