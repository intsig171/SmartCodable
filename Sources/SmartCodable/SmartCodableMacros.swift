
@attached(member, names: named(init(from:)), named(encode(to:)), named(CodingKeys), named(init))
public macro InheritedSmartCodable() = #externalMacro(module: "SmartCodableMacros", type: "SmartSubclassMacro")
