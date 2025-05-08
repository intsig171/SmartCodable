@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
@attached(extension, conformances: Codable)
public macro Codable(wiseInit: Bool = true) = #externalMacro(module: "CodableWrapperMacros", type: "Codable")

@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
public macro CodableSubclass() = #externalMacro(module: "CodableWrapperMacros", type: "CodableSubclass")

@attached(peer)
public macro CodingKey(_ key: String ...) = #externalMacro(module: "CodableWrapperMacros", type: "CodingKey")

@attached(peer)
public macro CodingNestedKey(_ key: String ...) = #externalMacro(module: "CodableWrapperMacros", type: "CodingNestedKey")

@attached(peer)
public macro CodingTransformer(_ transformer: any TransformType) = #externalMacro(module: "CodableWrapperMacros", type: "CodingTransformer")
