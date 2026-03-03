# HelloCoffee

`HelloCoffee` is a simple iOS app built with SwiftUI to manage coffee orders using a remote REST API.

## Purpose

This repository is a compact practical reference to learn:

- SwiftUI with `ObservableObject` state management
- Async/await networking with `URLSession`
- CRUD flow integration between UI, model, and web service
- Basic form validation and state-driven updates

## What this app does

- Lists all coffee orders
- Adds a new order (name, coffee, size, price)
- Edits an existing order
- Deletes orders from list and detail screens
- Shows order details with formatted price

## Main structure

- `HelloCoffee/HelloCoffeeApp.swift`: app entry point and dependency injection
- `HelloCoffee/Models/CoffeeModel.swift`: app state and order actions
- `HelloCoffee/Services/Webservice.swift`: API requests (GET/POST/PUT/DELETE)
- `HelloCoffee/Views/`: list, add/edit form, cell, and detail screens
- `HelloCoffee/Utils/AppEnvironment.swift`: base URL and endpoint paths

## How to run

1. Open `HelloCoffee.xcodeproj` in Xcode.
2. Select an iOS simulator.
3. Run with `Cmd + R`.

## Stack

- Swift
- SwiftUI
- URLSession (`async/await`)

## Note

This app uses a backend API (`https://azamsharp-server-dddabf536d7a.herokuapp.com`) for order persistence.
