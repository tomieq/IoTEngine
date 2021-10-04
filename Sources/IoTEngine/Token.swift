//
//  Token.swift
//  
//
//  Created by Tomasz Kucharski on 04/10/2021.
//

import Foundation


enum Token: Equatable {
    case floatLiteral(Float)
    case intLiteral(Int)
    case stringLiteral(String)
    case boolLiteral(Bool)
    case bracketOpen
    case bracketClose
    case ifStatement
    case elseStatement
    case returnStatement
    case blockOpen
    case blockClose
    case equals
    case function(name: String)
    case functionWithArguments(name: String)
}

// MARK: regex for tokens

extension Token {
    static let generators: [TokenGenerator] = Token.makeTokenGenerators()
    
    private static func makeTokenGenerators() -> [TokenGenerator] {
        var generators: [TokenGenerator] = []
        
        generators.append(TokenGenerator(regex: "true", resolver: { _ in [.boolLiteral(true)] }))
        generators.append(TokenGenerator(regex: "false", resolver: { _ in [.boolLiteral(false)] }))
        generators.append(TokenGenerator(regex: "if", resolver: { _ in [.ifStatement] }))
        generators.append(TokenGenerator(regex: "\\{", resolver: { _ in [.blockOpen] }))
        generators.append(TokenGenerator(regex: "\\}", resolver: { _ in [.blockClose] }))
        generators.append(TokenGenerator(regex: "==", resolver: { _ in [.equals] }))
        generators.append(TokenGenerator(regex: "else", resolver: { _ in [.elseStatement] }))
        generators.append(TokenGenerator(regex: "return", resolver: { _ in [.returnStatement] }))
        generators.append(TokenGenerator(regex: "\\(", resolver: { _ in [.bracketOpen] }))
        generators.append(TokenGenerator(regex: "\\)", resolver: { _ in [.bracketClose] }))
        generators.append(TokenGenerator(regex: "\\-?([0-9]*\\.[0-9]*)", resolver: { [.floatLiteral(Float($0)!)] }))
        generators.append(TokenGenerator(regex: "(\\d++)(?!\\.)", resolver: { [.intLiteral(Int($0)!)] }))
        generators.append(TokenGenerator(regex: "'[a-zA-Z_\\-0-9 ]*'", resolver: { [.stringLiteral($0.trimmingCharacters(in: CharacterSet(charactersIn: "'")))] }))
        generators.append(TokenGenerator(regex: "\"[a-zA-Z_\\-0-9 ']*\"", resolver: { [.stringLiteral($0.trimmingCharacters(in: CharacterSet(charactersIn: "\"")))] }))
        generators.append(TokenGenerator(regex: "[a-zA-Z0-9_]+\\(\\)", resolver: { [.function(name: $0.trimmingCharacters(in: CharacterSet(charactersIn: "()")))] }))
        generators.append(TokenGenerator(regex: "([a-zA-Z0-9_]+)\\((?!\\))", resolver: { [.functionWithArguments(name: $0.trimmingCharacters(in: CharacterSet(charactersIn: "()"))), .bracketOpen] }))
        return generators
    }
}

typealias TokenResolver = (String) -> [Token]?
struct TokenGenerator {
    
    let regex: String
    let resolver: TokenResolver
}

extension Token: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .floatLiteral(let value):
            return "floatLiteral(\(value))"
        case .intLiteral(let value):
            return "intLiteral(\(value))"
        case .bracketOpen:
            return "("
        case .bracketClose:
            return ")"
        case .blockOpen:
            return "{"
        case .blockClose:
            return "}"
        case .ifStatement:
            return "if"
        case .boolLiteral(let value):
            return "boolLiteral(\(value))"
        case .stringLiteral(let value):
            return "stringLiteral(\(value))"
        case .elseStatement:
            return "else"
        case .returnStatement:
            return "return"
        case .equals:
            return "equals"
        case .function(let name):
            return "function:\(name)"
        case .functionWithArguments(let name):
            return "functionWithArguments:\(name)"
        }
    }
}
