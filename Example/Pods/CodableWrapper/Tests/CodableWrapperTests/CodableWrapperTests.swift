import CodableWrapper
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@Codable
struct Basic0Model {
    var defaultVal: String = "hello world"
    var strict: String
    var noStrict: String?
    var autoConvert: Int?

    @CodingKey("customKey")
    var codingKeySupport: String
}

@Codable
struct BasicModel {
    var defaultVal: String = "hello world"
    var defaultVal2: String = Bool.random() ? "hello world" : ""
    let strict: String
    let noStrict: String?
    let autoConvert: Int?

    @CodingKey("hello")
    var hi: String = "there"

    @CodingNestedKey("nested.hi")
    @CodingTransformer(StringPrefixTransform("HELLO -> "))
    var codingKeySupport: String

    @CodingNestedKey("nested.b")
    var nestedB: String

    var testGetter: String {
        nestedB
    }
}

final class CodableWrapperTests: XCTestCase {
    func testBasicUsage() throws {
        let jsonStr = """
        {
            "strict": "value of strict",
            "autoConvert": "998",
            "nested": {
                "hi": "nested there",
                "b": "b value"
            }
        }
        """

        let model = try JSONDecoder().decode(BasicModel.self, from: jsonStr.data(using: .utf8)!)
        XCTAssertEqual(model.defaultVal, "hello world")
        XCTAssertEqual(model.strict, "value of strict")
        XCTAssertEqual(model.noStrict, nil)
        XCTAssertEqual(model.autoConvert, 998)
        XCTAssertEqual(model.hi, "there")
        XCTAssertEqual(model.codingKeySupport, "HELLO -> nested there")
        XCTAssertEqual(model.nestedB, "b value")

        let encoded = try JSONEncoder().encode(model)
        let dict = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual(model.defaultVal, dict["defaultVal"] as! String)
        XCTAssertEqual(model.strict, dict["strict"] as! String)
        XCTAssertNil(dict["noStrict"])
        XCTAssertEqual(model.autoConvert, dict["autoConvert"] as? Int)
        XCTAssertEqual(model.hi, dict["hello"] as! String)
        XCTAssertEqual("nested there", (dict["nested"] as! [String: Any])["hi"] as! String)
        XCTAssertEqual(model.nestedB, (dict["nested"] as! [String: Any])["b"] as! String)

        print(String(data: encoded, encoding: .utf8)!)
    }

    func testSystemCodableSubclass_v2() throws {
        class ClassModel: Codable {
            var val: String?
        }

        class ClassSubmodel: ClassModel {
            var subVal: String?

            enum CodingKeys: CodingKey {
                case subVal
            }

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                subVal = try container.decode(String.self, forKey: .subVal)
                try super.init(from: decoder)
            }

            override func encode(to encoder: Encoder) throws {
                try super.encode(to: encoder)
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(subVal, forKey: .subVal)
            }
        }

        let jsonStr = """
        {
            "val": "a",
            "subVal": "b",
        }
        """

        let model = try JSONDecoder().decode(ClassSubmodel.self, from: jsonStr.data(using: .utf8)!)
        XCTAssertEqual(model.val, "a")
        XCTAssertEqual(model.subVal, "b")
    }

    func testSystemCodableSubclass() throws {
        class ClassModel: Codable {
            var val: String?
        }

        class ClassSubmodel: ClassModel {
            var subVal: String?
        }

        let jsonStr = """
        {
            "val": "a",
            "subVal": "b",
        }
        """

        let model = try JSONDecoder().decode(ClassSubmodel.self, from: jsonStr.data(using: .utf8)!)
        XCTAssertEqual(model.val, "a")
        XCTAssertNotEqual(model.subVal, "b")
    }
}
