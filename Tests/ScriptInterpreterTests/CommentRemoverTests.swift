//
//  CommentRemoverTests.swift
//  
//
//  Created by Tomasz Kucharski on 04/02/2022.
//


import Foundation
import XCTest
@testable import ScriptInterpreter

class CommentRemoverTests: XCTestCase {
    
    func test_removingMultilineComment() {
        let script = """
/****
 * Common multi-line comment style.
 ****/text
"""
        let remover = CommentRemover(script: script)
        let text = remover.script
        XCTAssertEqual(text, " text")
    }
    
    
    func test_removingMultipleMultilineComment() {
        let script = """
/****
 * Common multi-line comment style.
 ****/one/*
    some comment that should be cut out! (tips)
*/two
"""
        let remover = CommentRemover(script: script)
        let text = remover.script
        XCTAssertEqual(text, " one two")
    }
}
