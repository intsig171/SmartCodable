////
////  PatternBindingSyntax+Extension.swift
////  SmartCodable
////
////  Created by qixin on 2025/5/14.
////
//
import SwiftSyntax

extension PatternBindingSyntax {
    
    /// 获取变量名称
    func getIdentifierPattern() throws -> IdentifierPatternSyntax {
        guard let identifier = pattern.as(IdentifierPatternSyntax.self) else {
            throw MacroError("Property '\(pattern.description)' must be an identifier (e.g., 'var name = ...').")
        }
        return identifier
    }
    
    
    /// 获取变量类型，var age：Int，即：Int
    func getVariableType() throws -> String {
        if let explicitType = self.typeAnnotation?.type.trimmedDescription {
            return explicitType
        }
        
        return try inferType()
    }
    
    // 推理类型
    private func inferType() throws -> String {
        guard let expr = self.initializer?.value else {
            throw MacroError.requiresExplicitType(for: pattern.trimmedDescription, inferredFrom: "missing initializer")
        }
        
        if expr.is(IntegerLiteralExprSyntax.self) {
            return "Int"
        } else if expr.is(FloatLiteralExprSyntax.self) {
            return "Double"
        } else if expr.is(BooleanLiteralExprSyntax.self) {
            return "Bool"
        } else if expr.is(StringLiteralExprSyntax.self) {
            return "String"
        } else if expr.is(ArrayExprSyntax.self) {
            throw MacroError.requiresExplicitType(for: pattern.trimmedDescription, inferredFrom: "array literal")
        } else if expr.is(DictionaryExprSyntax.self) {
            throw MacroError.requiresExplicitType(for: pattern.trimmedDescription, inferredFrom: "dictionary literal")

        } else if let callExpr = expr.as(FunctionCallExprSyntax.self) {
            let called = callExpr.calledExpression.trimmed.description
            switch called {
            case "Date": return "Date"
            case "UUID": return "UUID"
            case "Data": return "Data"
            default: break
            }
        }
        
        throw MacroError.requiresExplicitType(for: pattern.trimmedDescription, inferredFrom: "unrecognized expression")
    }
}
