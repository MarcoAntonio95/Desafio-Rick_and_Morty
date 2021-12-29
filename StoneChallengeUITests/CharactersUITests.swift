//
//  CharactersUITests.swift
//  StoneChallengeUITests
//
//  Created by Marco Antonio on 29/12/21.
//

import XCTest

class CharactersUITests: XCTestCase {

    let app = XCUIApplication()
    var charactersTableView: XCUIElement!
    var searchButton: XCUIElement!
    var filterNameTextfield: XCUIElement!
    var filterStatusSegmentControl: XCUIElement!
    var filterButton: XCUIElement!
    
    override func setUp() {
        self.charactersTableView = self.app.tables["charactersTableView"]
        self.searchButton = self.app.buttons["searchButton"]
        self.app.launch()
    }
    
    func testElementsVisibility() throws {
        XCTAssertTrue(self.charactersTableView.exists,"Characters tableview is hidden.")
        XCTAssertTrue(self.searchButton.exists,"Filter button is hidden.")
        XCTAssertTrue(self.app.staticTexts["CHARACTERS"].exists,"Title is hidden.")
    }
    
    func testIfElementsIsEnabled() throws {
        XCTAssertTrue(self.searchButton.isEnabled,"Filter button can't be tapped")
    }
    
    func testFilterElementsVisibility() throws {
        self.searchButton.tap()
        
        self.filterNameTextfield = self.app.textFields["filterNameTextfield"]
        self.filterStatusSegmentControl = self.app.segmentedControls["filterStatusSegmentControl"]
        self.filterButton = self.app.buttons["filterButton"]
       
        XCTAssertTrue(self.filterNameTextfield.exists,"Name textfield is hidden.")
        XCTAssertTrue(self.filterStatusSegmentControl.exists,"Status Segment Controller is hidden.")
        XCTAssertTrue(self.filterButton.exists,"Filter button is hidden.")
    }
    
    func testSimpleFilterFilling() throws {
        self.searchButton.tap()
        
        self.filterNameTextfield = self.app.textFields["filterNameTextfield"]
        self.filterStatusSegmentControl = self.app.segmentedControls["filterStatusSegmentControl"]
        self.filterButton = self.app.buttons["filterButton"]
        
        self.filterNameTextfield.tap()
        self.filterNameTextfield.typeText("Rick")
        let deadButton = filterStatusSegmentControl.buttons["Dead"]
        deadButton.tap()
    }

}
