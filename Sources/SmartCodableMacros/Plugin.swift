import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SmartCodablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InheritedSmartCodableMacro.self
    ]
}
