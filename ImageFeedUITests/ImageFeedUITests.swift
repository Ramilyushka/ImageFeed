//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Наиль on 25/10/23.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
    private let login = ""
    private let password = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launch() // запускаем приложение перед каждым тестом
    }

    // тестируем сценарий авторизации
    func testAuth() throws {
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        sleep(2)
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 7))
        
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(login)
        webView.swipeUp()
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        print(app.debugDescription)
    
        // Нажать кнопку логина
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        // Подождать, пока открывается экран ленты
        sleep(3)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        sleep(2)
        
        // Поставить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like button"].tap()
        
        // Отменить лайк в ячейке верхней картинки
        cellToLike.buttons["like button"].tap()
        sleep(2)
        
        // Нажать на верхнюю ячейку
        cellToLike.tap()
        sleep(2)
        
        // Подождать, пока картинка открывается на весь экран
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(5)
        
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1) // zoom in
         
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        
        // Вернуться на экран ленты
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
      
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        // Нажать кнопку логаута
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Yes"].tap()
        
        // Проверить, что открылся экран авторизации
        sleep(1)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
