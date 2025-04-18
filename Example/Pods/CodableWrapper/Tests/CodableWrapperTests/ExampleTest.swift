////
////  ExampleTest.swift
////  CodableWrapperTest
////
////  Created by PAN on 2020/7/16.
////
//
import CodableWrapper
import XCTest

enum Animal: String, Codable {
    case dog
    case cat
    case fish
}

@Codable
struct ExampleModel: Codable {
    @CodingKey("aString")
    var stringVal: String = "scyano"

    @CodingKey("aInt")
    var intVal: Int? = 123_456

    var array: [Double] = [1.998, 2.998, 3.998]

    var bool: Bool = false

    var bool2: Bool = true

    var unImpl: String?

    var animal: Animal = .dog

    var testInt: Int?

    var testFloat: Float?

    @CodingKey("1") var testBool: Bool? = nil

    var testFloats: [Float]?

    static var empty: ExampleModel = .init()
}

@Codable
struct SimpleModel {
    var a, b: Int
    var val: Int = 2
}

@Codable
struct OptionalModel {
    var val: String? = "default"
}

@Codable
struct OptionalNullModel {
    var val: String?
}

@Codable
struct RootModel: Codable {
    @CodingKey("rt") var root: SubRootModelCodec = .init(value: nil, value2: ExampleModel())
    var root2: SubRootModel? = SubRootModel(value: nil, value2: nil, value3: nil)
}

@Codable
struct SubRootModelCodec {
    var value: ExampleModel?
    var value2: ExampleModel = .init()
}

@Codable
struct SubRootModel {
    var value: ExampleModel?
    var value2: ExampleModel?
    var value3: ExampleModel? = .init()
}

@Codable
struct SnakeCamelModel {
    var snake_string: String = ""
    var camelString: String = ""
}

class ExampleTest: XCTestCase {
    private var didSetCount = 0
    var setTestModel: ExampleModel? {
        didSet {
            didSetCount += 1
        }
    }

    override class func setUp() {}

    func testStructCopyOnWrite() {
        let a = ExampleModel()
        let valueInA = a.stringVal
        var b = a
        b.stringVal = "changed!"
        XCTAssertEqual(a.stringVal, valueInA)
    }

    func testBasicUsage() throws {
        let json = #"{"stringVal": "pan", "intVal": "233", "bool": "1", "animal": "cat"}"#
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.intVal, 233)
        XCTAssertEqual(model.stringVal, "pan")
        XCTAssertEqual(model.unImpl, nil)
        XCTAssertEqual(model.array, [1.998, 2.998, 3.998])
        XCTAssertEqual(model.bool, true)
        XCTAssertEqual(model.animal, .cat)
    }

    func testCodingKeyEncode() throws {
        let json = """
        {"intVal": 233, "stringVal": "pan"}
        """
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)

        let data = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        XCTAssertEqual(jsonObject["aInt"] as? Int, 233)
        XCTAssertEqual(jsonObject["aString"] as? String, "pan")
    }

    func testSnakeCamel() throws {
        let json = #"{"snakeString":"snake", "camel_string": "camel"}"#

        let model = try JSONDecoder().decode(SnakeCamelModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.snake_string, "snake")
        XCTAssertEqual(model.camelString, "camel")
    }

    func testCodingKeyDecode() throws {
        let json = """
        {"aString": "pan", "aInt": "233"}
        """
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.intVal, 233)
        XCTAssertEqual(model.stringVal, "pan")
    }

    func testDefaultVale() throws {
        let json = """
        {"intVal": "wrong value"}
        """
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.intVal, 123_456)
        XCTAssertEqual(model.stringVal, "scyano")
        XCTAssertEqual(model.animal, .dog)
    }

    func testNested() throws {
        let json = """
        {"rt": {"value": {"stringVal":"x"}}, "root2": {"value": {"stringVal":"y"}}}
        """
        let model = try JSONDecoder().decode(RootModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.root.value?.stringVal, "x")
        XCTAssertEqual(model.root.value2.stringVal, "scyano")
        XCTAssertEqual(model.root2?.value?.stringVal, "y")
        XCTAssertEqual(model.root2?.value2?.stringVal, nil)
        XCTAssertEqual(model.root2?.value3?.stringVal, "scyano")
    }

    func testDidSet() throws {
        didSetCount = 0

        let json = """
        {"intVal": 233, "stringVal": "pan"}
        """
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
        setTestModel = model
        setTestModel!.intVal = 222
        setTestModel!.stringVal = "ok"

        XCTAssertEqual(didSetCount, 3)
    }

    func testLiteral() throws {
        let model = ExampleModel(stringVal: "1", intVal: 1, array: [], bool: true, bool2: true, unImpl: "123", animal: .cat, testInt: 111, testFloat: 1.2, testBool: true, testFloats: [1, 2])
        XCTAssertEqual(model.unImpl, "123")
        XCTAssertEqual(model.testFloats, [1, 2])
    }

    func testOptionalWithValue() throws {
        let json = """
        {"val": "default2"}
        """
        let model = try JSONDecoder().decode(OptionalModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.val, "default2")
    }

    func testOptionalWithNull() throws {
        let json = """
        {"val": null}
        """
        let model = try JSONDecoder().decode(OptionalNullModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.val, nil)

        let json2 = """
        {}
        """
        let model2 = try JSONDecoder().decode(OptionalNullModel.self, from: json2.data(using: .utf8)!)
        XCTAssertEqual(model2.val, nil)
    }

    func testBasicTypeBridge() throws {
        let json = """
        {"intVal": "1", "stringVal": 2, "bool": "true"}
        """
        let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.intVal, 1)
        XCTAssertEqual(model.stringVal, "2")
        XCTAssertEqual(model.bool, true)

        let jsonData = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        XCTAssertEqual(jsonObject["aString"] as? String, "2")
    }

    func testMutiThread() throws {
        let expectation = XCTestExpectation(description: "")
        let expectation2 = XCTestExpectation(description: "")

        var array: [ExampleModel] = []
        var array2: [ExampleModel] = []

        DispatchQueue.global().async {
            do {
                for i in 5000 ..< 6000 {
                    let json = """
                    {"intVal": \(i)}
                    """
                    let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
                    XCTAssertEqual(model.intVal, i)
                    XCTAssertEqual(model.stringVal, "scyano")
                    XCTAssertEqual(model.unImpl, nil)
                    XCTAssertEqual(model.array, [1.998, 2.998, 3.998])
                    // print(model.intVal)

                    array.append(model)
                }
                expectation.fulfill()
            } catch let e {
                print(e)
            }
        }

        DispatchQueue.global().async {
            do {
                for i in 1 ..< 1000 {
                    let json = """
                    {"intVal": \(i), "stringVal": "string_\(i)", "array": [123456789]}
                    """
                    let model = try JSONDecoder().decode(ExampleModel.self, from: json.data(using: .utf8)!)
                    XCTAssertEqual(model.intVal, i)
                    XCTAssertEqual(model.stringVal, "string_\(i)")
                    XCTAssertEqual(model.unImpl, nil)
                    XCTAssertEqual(model.array, [123_456_789])

                    array2.append(model)
                }
                expectation2.fulfill()
            } catch let e {
                print(e)
            }
        }

        wait(for: [expectation, expectation2], timeout: 10.0)
    }
}
