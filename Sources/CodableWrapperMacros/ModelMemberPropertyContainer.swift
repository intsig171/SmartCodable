import SwiftSyntax
import SwiftSyntaxMacros

private struct ModelMemberProperty {
    var name: String
    var type: String
    var modifiers: DeclModifierListSyntax = []
    var isOptional: Bool = false
    var normalKeys: [String] = []
    var nestedKeys: [String] = []
    var transformerExpr: String?
    var initializerExpr: String?

    var codingKeys: [String] {
        let raw = ["\"\(name)\""]
        if normalKeys.isEmpty {
            return raw
        }
        return normalKeys + raw
    }
}

struct ModelMemberPropertyContainer {
    struct AttributeOption: OptionSet {
        let rawValue: UInt

        static let open = AttributeOption(rawValue: 1 << 0)
        static let `public` = AttributeOption(rawValue: 1 << 1)
        static let required = AttributeOption(rawValue: 1 << 2)
    }

    struct GenConfig {
        let isOverride: Bool
    }

    let context: MacroExpansionContext
    fileprivate let decl: DeclGroupSyntax
    fileprivate var memberProperties: [ModelMemberProperty] = []

    init(decl: DeclGroupSyntax, context: some MacroExpansionContext) throws {
        self.decl = decl
        self.context = context
        memberProperties = try fetchModelMemberProperties()
    }

    private func attributesPrefix(option: AttributeOption) -> String {
        let hasPublicProperites = memberProperties.contains(where: {
            $0.modifiers.contains(where: {
                $0.name.text == "public" || $0.name.text == "open"
            })
        })

        let modifiers = decl.modifiers.compactMap { $0.name.text }
        var attributes: [String] = []
        if option.contains(.open), modifiers.contains("open") {
            attributes.append("open")
        } else if option.contains(.public), hasPublicProperites || modifiers.contains("open") || modifiers.contains("public") {
            attributes.append("public")
        }
        if option.contains(.required), decl.is(ClassDeclSyntax.self) {
            attributes.append("required")
        }
        if !attributes.isEmpty {
            attributes.append("")
        }

        return attributes.joined(separator: " ")
    }

    func genDecoderInitializer(config: GenConfig) throws -> DeclSyntax {
        let body = memberProperties.enumerated().map { idx, member in
            if let transformerExpr = member.transformerExpr {
                let transformerVar = context.makeUniqueName(String(idx))
                let tempJsonVar = member.name

                var text = """
                let \(transformerVar) = \(transformerExpr)
                let \(tempJsonVar) = try? container.decode(type: Swift.type(of: \(transformerVar)).JSON.self, keys: [\(member.codingKeys.joined(separator: ", "))], nestedKeys: [\(member.nestedKeys.joined(separator: ", "))])
                """

                if let initializerExpr = member.initializerExpr {
                    text.append("""
                    self.\(member.name) = \(transformerVar).transformFromJSON(\(tempJsonVar), fallback: \(initializerExpr))
                    """)
                } else {
                    text.append("""
                    self.\(member.name) = \(transformerVar).transformFromJSON(\(tempJsonVar))
                    """)
                }

                return text
            } else {
                let body = "container.decode(type: \(member.type).self, keys: [\(member.codingKeys.joined(separator: ", "))], nestedKeys: [\(member.nestedKeys.joined(separator: ", "))])"

                if let initializerExpr = member.initializerExpr {
                    return "self.\(member.name) = (try? \(body)) ?? (\(initializerExpr))"
                } else {
                    return "self.\(member.name) = try \(body)"
                }
            }
        }
        .joined(separator: "\n")

        let decoder: DeclSyntax = """
        \(raw: attributesPrefix(option: [.public, .required]))init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: AnyCodingKey.self)
            \(raw: body)\(raw: config.isOverride ? "\ntry super.init(from: decoder)" : "")
        }
        """

        return decoder
    }

    func genEncodeFunction(config: GenConfig) throws -> DeclSyntax {
        let body = memberProperties.enumerated().map { idx, member in
            if let transformerExpr = member.transformerExpr {
                let transformerVar = context.makeUniqueName(String(idx))

                if member.isOptional {
                    return """
                    let \(transformerVar) = \(transformerExpr)
                    if let \(member.name) = self.\(member.name), let value = \(transformerVar).transformToJSON(\(member.name)) {
                        try container.encode(value: value, keys: [\(member.codingKeys.joined(separator: ", "))], nestedKeys: [\(member.nestedKeys.joined(separator: ", "))])
                    }
                    """
                } else {
                    return """
                    let \(transformerVar) = \(transformerExpr)
                    if let value = \(transformerVar).transformToJSON(self.\(member.name)) {
                        try container.encode(value: value, keys: [\(member.codingKeys.joined(separator: ", "))], nestedKeys: [\(member.nestedKeys.joined(separator: ", "))])
                    }
                    """
                }

            } else {
                return "try container.encode(value: self.\(member.name), keys: [\(member.codingKeys.joined(separator: ", "))], nestedKeys: [\(member.nestedKeys.joined(separator: ", "))])"
            }
        }
        .joined(separator: "\n")

        let encoder: DeclSyntax = """
        \(raw: attributesPrefix(option: [.open, .public]))\(raw: config.isOverride ? "override " : "")func encode(to encoder: Encoder) throws {
            \(raw: config.isOverride ? "try super.encode(to: encoder)\n" : "")let container = encoder.container(keyedBy: AnyCodingKey.self)
            \(raw: body)
        }
        """

        return encoder
    }

    func genMemberwiseInit(config: GenConfig) throws -> DeclSyntax {
        let parameters = memberProperties.map { property in
            var text = property.name
            text += ": " + property.type
            if let initializerExpr = property.initializerExpr {
                text += "= \(initializerExpr)"
            } else if property.isOptional {
                text += "= nil"
            }
            return text
        }

        let overrideInit = config.isOverride ? "super.init()\n" : ""

        return
            """
            \(raw: attributesPrefix(option: [.public]))init(\(raw: parameters.joined(separator: ", "))) {
                \(raw: overrideInit)\(raw: memberProperties.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n"))
            }
            """ as DeclSyntax
    }
}

private extension ModelMemberPropertyContainer {
    func fetchModelMemberProperties() throws -> [ModelMemberProperty] {
        let memberList = decl.memberBlock.members
        let memberProperties = try memberList.flatMap { member -> [ModelMemberProperty] in
            guard let variable = member.decl.as(VariableDeclSyntax.self), variable.isStoredProperty else {
                return []
            }
            let patterns = variable.bindings.map(\.pattern)
            let names = patterns.compactMap { $0.as(IdentifierPatternSyntax.self)?.identifier.text }

            return try names.compactMap { name -> ModelMemberProperty? in
                guard !variable.isLazyVar else {
                    return nil
                }
                guard let type = variable.inferType else {
                    throw ASTError("please declare property type: \(name)")
                }

                var mp = ModelMemberProperty(name: name, type: type)
                mp.modifiers = variable.modifiers
                let attributes = variable.attributes

                // isOptional
                mp.isOptional = variable.isOptionalType

                // CodingKey
                if let customKeyMacro = attributes.first(where: { element in
                    element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "CodingKey"
                }) {
                    mp.normalKeys = customKeyMacro.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)?.compactMap { $0.expression.description } ?? []
                }

                // CodingNestedKey
                if let customKeyMacro = attributes.first(where: { element in
                    element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "CodingNestedKey"
                }) {
                    mp.nestedKeys = customKeyMacro.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)?.compactMap { $0.expression.description } ?? []
                }

                // CodableTransform
                if let customKeyMacro = attributes.first(where: { element in
                    element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "CodingTransformer"
                }) {
                    mp.transformerExpr = customKeyMacro.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.description
                }

                // initializerExpr
                if let initializer = variable.bindings.compactMap(\.initializer).first {
                    mp.initializerExpr = initializer.value.description
                }
                return mp
            }
        }
        return memberProperties
    }
}
