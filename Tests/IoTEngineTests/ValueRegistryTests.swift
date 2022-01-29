//
//  ValueRegistryTests.swift
//  
//
//  Created by Tomasz Kucharski on 28/01/2022.
//

import Foundation
import XCTest
@testable import IoTEngine

final class ValueRegistryTests: XCTestCase {

    func test_registerNullVariable() {
        let registry = ValueRegistry()
        XCTAssertFalse(registry.valueExists(name: "amount"))
        registry.registerValue(name: "amount", value: nil)
        XCTAssertTrue(registry.valueExists(name: "amount"))
    }
    
    func test_registerNonNullVariable() {
        let registry = ValueRegistry()
        XCTAssertFalse(registry.valueExists(name: "amount"))
        registry.registerValue(name: "amount", value: .integer(20))
        XCTAssertTrue(registry.valueExists(name: "amount"))
        XCTAssertEqual(registry.getValue(name: "amount"), .integer(20))
    }
    
    func test_reisterVariableInHigherNamespace() {
        let outer = ValueRegistry()
        let inner = ValueRegistry(upperValueRegistry: outer)
        XCTAssertFalse(outer.valueExists(name: "amount"))
        XCTAssertFalse(inner.valueExists(name: "amount"))
        outer.registerValue(name: "amount", value: .integer(31))
        XCTAssertTrue(outer.valueExists(name: "amount"))
        XCTAssertTrue(inner.valueExists(name: "amount"))
        
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(31))
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(31))
    }
    
    func test_reisterVariableInLowerNamespace() {
        let outer = ValueRegistry()
        let inner = ValueRegistry(upperValueRegistry: outer)
        XCTAssertFalse(outer.valueExists(name: "amount"))
        XCTAssertFalse(inner.valueExists(name: "amount"))
        inner.registerValue(name: "amount", value: .integer(31))
        XCTAssertFalse(outer.valueExists(name: "amount"))
        XCTAssertTrue(inner.valueExists(name: "amount"))
        
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(31))
        XCTAssertNil(outer.getValue(name: "amount"))
    }
    
    func test_reisterVariableInBothNamespaces() {
        let outer = ValueRegistry()
        let inner = ValueRegistry(upperValueRegistry: outer)
        XCTAssertFalse(outer.valueExists(name: "amount"))
        XCTAssertFalse(inner.valueExists(name: "amount"))
        
        outer.registerValue(name: "amount", value: .integer(20))
        inner.registerValue(name: "amount", value: .integer(100))
        
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(20))
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(100))
    }
    
    func test_updateVariableInHigherNamespace() {
        let outer = ValueRegistry()
        let inner = ValueRegistry(upperValueRegistry: outer)
        
        outer.registerValue(name: "amount", value: .integer(20))
        
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(20))
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(20))
        
        XCTAssertNoThrow(try outer.updateValue(name: "amount", value: .integer(50)))
        
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(50))
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(50))
    }
    
    func test_updateVariableInLowerNamespace() {
        let outer = ValueRegistry()
        let inner = ValueRegistry(upperValueRegistry: outer)
        
        outer.registerValue(name: "amount", value: .integer(20))
        
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(20))
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(20))
        
        XCTAssertNoThrow(try inner.updateValue(name: "amount", value: .integer(50)))
        
        XCTAssertEqual(outer.getValue(name: "amount"), .integer(50))
        XCTAssertEqual(inner.getValue(name: "amount"), .integer(50))
    }
}
