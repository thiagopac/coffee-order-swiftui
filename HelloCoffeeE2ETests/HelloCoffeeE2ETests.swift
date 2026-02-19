//
//  HelloCoffeeE2ETests.swift
//  HelloCoffee
//
//  Created by Thiago Castro on 12/02/26.
//


import XCTest

final class WhenAppIsLaunchedWithNoOrders: XCTestCase {

    @MainActor
    func testShouldMakeSureNoOrdersMessageIsDisplayed() throws {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]

        app.launch()
        
        XCTAssertEqual("No orders available!", app.staticTexts["noOrdersText"].label)

    }
}

final class WhenAddingANewCoffeeOrder: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]

        app.launch()
        
        app.buttons["addNewOrderButton"].tap()
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Magnus")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Iced Tea")
        
        priceTextField.tap()
        priceTextField.typeText("1.80")
        
        placeOrderButton.tap()
    }
    
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://azamsharp-server-dddabf536d7a.herokuapp.com")) else { return }
            
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
    func testShouldDisplayCoffeeOrderInListSuccessfully() throws {
        XCTAssertEqual("Magnus", app.staticTexts["orderNameText"].label)
        XCTAssertEqual("Iced Tea (Medium)", app.staticTexts["coffeeNameAndSizeText"].label)
        
        let expected = NumberFormatter.currency.string(from: 1.80 as NSNumber)
        XCTAssertEqual(expected, app.staticTexts["coffeePriceText"].label)
    }
}

final class WhenDeletingACoffeeOrder: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]

        app.launch()
        
        app.buttons["addNewOrderButton"].tap()
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Magnus")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Iced Tea")
        
        priceTextField.tap()
        priceTextField.typeText("1.80")
        
        placeOrderButton.tap()
    }
    
    func testShouldDeleteOrderSuccessfully() throws {
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cellsQuery = collectionViewsQuery.cells
        let element = cellsQuery.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeLeft()
        collectionViewsQuery.buttons["Delete"].tap()
        
        let orderList = app.collectionViews["orderList"]
        XCTAssertEqual(0, orderList.cells.count)
    }
    
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://azamsharp-server-dddabf536d7a.herokuapp.com")) else { return }
            
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
}

final class WhenUpdatingACoffeeOrder: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]

        app.launch()
        
        app.buttons["addNewOrderButton"].tap()
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Magnus")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Iced Tea")
        
        priceTextField.tap()
        priceTextField.typeText("1.80")
        
        placeOrderButton.tap()
    }
    
    func testShouldUpdateOrderSuccessfully() throws {
        
        let orderList = app.collectionViews["orderList"]
        orderList.buttons["orderNameText-coffeeNameAndSizeText-coffeePriceText"].tap()
        app.buttons["editOrderButton"].tap()
        
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 2.0)
        nameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        nameTextField.typeText("Leonel Arno")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 2.0)
        coffeeNameTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        coffeeNameTextField.typeText("Green Tea")
        
        let _ = priceTextField.waitForExistence(timeout: 2.0)
        priceTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        priceTextField.typeText("9.99")

        placeOrderButton.tap()
        
        XCTAssertEqual("Leonel Arno", app.staticTexts["nameText"].label)
        XCTAssertEqual("Green Tea", app.staticTexts["coffeeNameText"].label)
        let expected = NumberFormatter.currency.string(from: 9.99 as NSNumber)
        XCTAssertEqual(expected, app.staticTexts["coffeePriceText"].label)
    }
    
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://azamsharp-server-dddabf536d7a.herokuapp.com")) else { return }
            
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
}
