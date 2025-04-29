//
//  MemberMacro.swift
//  Mccc
//
//  Created by qixin on 2025/4/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public enum MacroError: Error, CustomStringConvertible {
    case message(String)
    
    public var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}


/// Represents information about a property in a class
struct PropertyInfo {
    let name: String
    let type: String
    let isStored: Bool
      
    var codingKeyName: String {
        return name
    }
}
  
/// A macro that automatically implements SmartCodable inheritance support
public struct InheritedSmartCodableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 确保是类声明
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw MacroError.message("@InheritedSmartCodable 只能用于类")
        }
          
        // 获取类的属性
        let properties = extractProperties(from: classDecl)
          
        // 如果没有属性，则不需要生成任何代码
        if properties.isEmpty {
            return []
        }
          
        // 生成CodingKeys枚举
        let codingKeysDecl = generateCodingKeysEnum(for: properties)
          
        // 生成init(from:)方法
        let initFromDecoder = generateInitFromDecoder(for: properties)
          
        // 生成encode(to:)方法
        let encodeToEncoder = generateEncodeToEncoder(for: properties)
          
        // 生成required init()方法
        let requiredInit = generateRequiredInit()
          
        return [codingKeysDecl, initFromDecoder, encodeToEncoder, requiredInit]
    }
      
    // 辅助方法：提取类的属性
    private static func extractProperties(from classDecl: ClassDeclSyntax) -> [PropertyInfo] {
        var properties: [PropertyInfo] = []
          
        for member in classDecl.memberBlock.members {
            // 只处理变量声明
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  varDecl.bindingSpecifier.text == "var" else {
                continue
            }
              
            // 遍历所有绑定
            for binding in varDecl.bindings {
                // 确保有标识符和类型注解
                guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
                      let typeAnnotation = binding.typeAnnotation else {
                    continue
                }
                  
                let name = identifier.identifier.text
                let type = typeAnnotation.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
                  
                // 检查是否是存储属性（有初始值或没有getter/setter）
                let isStored = binding.accessorBlock == nil ||
                               (binding.accessorBlock?.accessors.as(AccessorDeclListSyntax.self) == nil &&
                                binding.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self) == nil)
                  
                // 只添加存储属性
                if isStored {
                    properties.append(PropertyInfo(name: name, type: type, isStored: true))
                }
            }
        }
          
        return properties
    }
      
    // 辅助方法：生成CodingKeys枚举
    private static func generateCodingKeysEnum(for properties: [PropertyInfo]) -> DeclSyntax {
        let caseDeclarations = properties.map { property in
            "case \(property.codingKeyName)"
        }.joined(separator: "\n        ")
          
        return """
        enum CodingKeys: CodingKey {
            \(raw: caseDeclarations)
        }
        """
    }
      
    // 辅助方法：生成init(from:)方法
    private static func generateInitFromDecoder(for properties: [PropertyInfo]) -> DeclSyntax {
        let decodingStatements = properties.map { property in
            let propertyName = property.name
            let propertyType = property.type
              
            // 处理可选类型
            if propertyType.hasSuffix("?") {
                let baseType = propertyType.dropLast()
                return "self.\(propertyName) = try container.decodeIfPresent(\(baseType).self, forKey: .\(property.codingKeyName)) ?? self.\(propertyName)"
            } else {
                return "self.\(propertyName) = try container.decodeIfPresent(\(propertyType).self, forKey: .\(property.codingKeyName)) ?? self.\(propertyName)"
            }
        }.joined(separator: "\n        ")
          
        return """
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
              
            let container = try decoder.container(keyedBy: CodingKeys.self)
            \(raw: decodingStatements)
        }
        """
    }
      
    // 辅助方法：生成encode(to:)方法
    private static func generateEncodeToEncoder(for properties: [PropertyInfo]) -> DeclSyntax {
        let encodingStatements = properties.map { property in
            "try container.encode(\(property.name), forKey: .\(property.codingKeyName))"
        }.joined(separator: "\n        ")
          
        return """
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
              
            var container = encoder.container(keyedBy: CodingKeys.self)
            \(raw: encodingStatements)
        }
        """
    }
      
    // 辅助方法：生成required init()方法
    private static func generateRequiredInit() -> DeclSyntax {
        return """
        override required init() {
            super.init()
        }
        """
    }
}
