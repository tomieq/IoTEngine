//
//  Parser.swift
//  
//
//  Created by Tomasz Kucharski on 28/01/2022.
//

import Foundation

enum ParserError: Error {
    case syntaxError(description: String)
}

class Parser {
    private let lexicalAnalizer: LexicalAnalyzer
    private let functionRegistry: FunctionRegistry
    private let valueRegistry: ValueRegistry
    
    private var tokens: [Token]
    
    init(lexicalAnalizer: LexicalAnalyzer, functionRegistry: FunctionRegistry, valueRegistry: ValueRegistry) {
        self.lexicalAnalizer = lexicalAnalizer
        self.functionRegistry = functionRegistry
        self.valueRegistry = valueRegistry
        self.tokens = self.lexicalAnalizer.lexer.tokens
    }
    
    private func consumeTokensForInitVariablesInRegistry() throws {
        let tokensCopy = self.tokens
        for (index, token) in tokensCopy.enumerated() {
            switch token {
            case .variableDefinition(let definitionType):
                let tokenIndex = index + 1
                try self.initVariable(variableTokenIndex: tokenIndex, definitionType: definitionType)
            default:
                break
            }
        }
    }
    
    private func initVariable(variableTokenIndex pos: Int, definitionType: String) throws {
        guard case .variable(let name) = self.tokens[safeIndex: pos] else {
            throw ParserError.syntaxError(description: "Invalid \(definitionType) usage!")
        }
        self.valueRegistry.registerValue(name: name, value: nil)
    }
    
    func execute() throws {
        try self.consumeTokensForInitVariablesInRegistry()
        for (index, token) in self.tokens.enumerated() {
            switch token {
            case .function(let name):
                try self.functionRegistry.callFunction(name: name)
            case .functionWithArguments(let name):
                let tokens = self.lexicalAnalizer.getTokensBetweenBrackets(indexOfOpeningBracket: index + 1)
                try self.functionRegistry.callFunction(name: name, args: tokens.compactMap { self.token2Value($0) })
                break
            default:
                break
            }
        }
    }
    
    private func token2Value(_ token: Token) -> Value? {
        switch token {
        case .intLiteral(let value):
            return .integer(value)
        case .stringLiteral(let value):
            return .string(value)
        case .boolLiteral(let value):
            return .bool(value)
        case .floatLiteral(let value):
            return .float(value)
        default:
            return nil
        }
    }
}
