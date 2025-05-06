import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
@testable import SmartCodable

import SmartCodableMacros

let testMacros: [String: Macro.Type] = [
    "SmartSubclass": SmartSubclassMacro.self
    
]

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCodableSubclassExpansion() {
        assertMacroExpansion(
            """
            @SmartSubclass
            class UserModel: BaseModel {
                @SmartAny
                var age: Int = 0
            }
            """,
            expandedSource: """
            class UserModel: BaseModel {
                @SmartAny
                var age: Int = 0
            
                enum CodingKeys: CodingKey {
                    case age
                }

                required init(from decoder: Decoder) throws {
                    try super.init(from: decoder)

                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? self.age
                }

                override func encode(to encoder: Encoder) throws {
                    try super.encode(to: encoder)

                    var container = encoder.container(keyedBy: CodingKeys.self)
                    try container.encode(age, forKey: .age)
                }

                required init() {
                    super.init()
                }
            }
            """,
            macros: testMacros
        )
    }
    
    
    func testBase() {
        let dict: [String: Any] = [
            "name": "Mccc",
            "age": 10,
            "sex": 1
        ]
        
        guard let model = Smart.deserialize(from: dict) else {
            XCTFail("反序列化失败")
            return
        }
        XCTAssertEqual(model.name, "Mccc", "Smart 的 name 应该被正确处理为字符串 'Mccc'")
        XCTAssertEqual(model.age, 10, "Smart 的 age  应该被正确处理为Int '10'")
        XCTAssertEqual(model.sex, Smart.Sex.man, "Smart 的 sex 应该被正确的处理为 Sex枚举 ‘Sex.man’")
        
        print(model)
        
    }
    
}

// SmartCodable
struct Smart: SmartCodable {
    var name: String?
    var age: Int?
    var sex: Sex?
    
    enum Sex: Int, SmartCaseDefaultable {
        case man = 1
        case women = 0
    }
}


