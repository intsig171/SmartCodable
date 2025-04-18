//
//  TransformTest.swift
//  CodableWrapperTest
//
//  Created by winddpan on 2020/8/21.
//

import CodableWrapper
import XCTest

struct DateWrapper {
    let timestamp: TimeInterval

    var date: Date {
        Date(timeIntervalSince1970: timestamp)
    }

    init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    static var transformer = TransformOf<DateWrapper, TimeInterval>(fromJSON: { DateWrapper(timestamp: $0 ?? 0) }, toJSON: { $0.timestamp })
}

enum EnumInt: Int, Codable {
    case zero, one, two, three

    static var transformer: TransformOf<EnumInt, Int> {
        return TransformOf(fromJSON: { json in
                               if let json = json, let result = EnumInt(rawValue: json) {
                                   return result
                               }
                               return .zero
                           },
                           toJSON: { $0.rawValue })
    }

    static var optionalTransformer: TransformOf<EnumInt?, Int> {
        return TransformOf(fromJSON: { json in
                               if let json = json, let result = EnumInt(rawValue: json) {
                                   return result
                               }
                               return nil
                           },
                           toJSON: { $0?.rawValue })
    }
}

@Codable
struct StringModel {
    @CodingTransformer(StringPrefixTransform("hello:"))
    var title: String = "world"
}

@Codable
struct DateModel {
    @CodingTransformer(DateWrapper.transformer)
    var time: DateWrapper? = .init(timestamp: 0)

    @CodingTransformer(DateWrapper.transformer)
    var time1: DateWrapper = .init(timestamp: 0)

    @CodingTransformer(DateWrapper.transformer)
    var time2: DateWrapper?

    @CodingTransformer(DateWrapper.transformer)
    var time3: DateWrapper
}

struct DateModel_produce: Codable {
    var time: DateWrapper?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        let time = try container.decode(type: Swift.type(of: DateWrapper.transformer).JSON.self, keys: ["time"], nestedKeys: [])
        self.time = DateWrapper.transformer.transformFromJSON(time)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        if let value = DateWrapper.transformer.transformToJSON(time ?? .init(timestamp: 0)) {
            try container.encode(value, forKey: .init(stringValue: "time")!)
        }
    }

    init(time: DateWrapper) {
        self.time = time
    }
}

struct ValueWrapper: Equatable, Codable {
    var value: String?
}

@Codable
struct TransformExampleModel {
    @CodingTransformer(TransformOf<ValueWrapper, String>(fromJSON: { ValueWrapper(value: $0) }, toJSON: { $0.value }))
    var valueA: ValueWrapper = .init(value: "A")

    @CodingTransformer(TransformOf<ValueWrapper?, String>(fromJSON: { ValueWrapper(value: $0) }, toJSON: { $0?.value }))
    var valueB: ValueWrapper? = .init(value: "B")

    @CodingTransformer(TransformOf<ValueWrapper?, String>(fromJSON: { $0 != nil ? ValueWrapper(value: $0) : nil }, toJSON: { $0?.value }))
    var valueC: ValueWrapper? = .init(value: "C")

    @CodingTransformer(TransformOf<ValueWrapper?, String>(fromJSON: { $0 != nil ? ValueWrapper(value: $0) : nil }, toJSON: { $0?.value }))
    var valueD: ValueWrapper?
}

@Codable
struct CustomUnOptional: Codable {
    @CodingTransformer(EnumInt.transformer)
    var one: EnumInt = .three

    @CodingTransformer(EnumInt.transformer)
    var two: EnumInt?
}

@Codable
struct CustomOptional: Codable {
    @CodingTransformer(EnumInt.optionalTransformer)
    var one: EnumInt = .three

    @CodingTransformer(EnumInt.optionalTransformer)
    var two: EnumInt?
}

@Codable
struct CustomTransformCodec {
    var id: Int = 0

    @CodingKey("tuple", "tp")
    @CodingTransformer(tupleTransform)
    var tuple: (String, String)?

    @CodingTransformer(tupleTransform)
    var tupleOptional: (String, String)?
}

class TransformTest: XCTestCase {
    func testBuild() {}

    func testStringTransform() throws {
        let json = """
        {"title": "json"}
        """

        let model = try JSONDecoder().decode(StringModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.title, "hello:json")
    }

    func testDateModel() throws {
        let json = """
        {"time": 12345}
        """

        let model = try JSONDecoder().decode(DateModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.time?.timestamp, 12345)
        XCTAssertEqual(model.time?.date.description, "1970-01-01 03:25:45 +0000")

        let encode = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: encode, options: []) as! [String: Any]
        XCTAssertEqual(jsonObject["time"] as! TimeInterval, 12345)
    }

    func testDateModel_produce() throws {
        let json = """
        {"time": 12345}
        """

        let model = try JSONDecoder().decode(DateModel_produce.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.time?.timestamp, 12345)
        XCTAssertEqual(model.time?.date.description, "1970-01-01 03:25:45 +0000")

        let encode = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: encode, options: []) as! [String: Any]
        XCTAssertEqual(jsonObject["time"] as! TimeInterval, 12345)
    }

    func testTransformOf() throws {
        let fullModel = try JSONDecoder().decode(TransformExampleModel.self, from: #"{"valueA": "something_a", "valueB": "something_b", "valueC": "something_c", "valueD": "something_d"}"#.data(using: .utf8)!)
        let emptyModel = try JSONDecoder().decode(TransformExampleModel.self, from: #"{}"#.data(using: .utf8)!)

        XCTAssertEqual(fullModel.valueA, ValueWrapper(value: "something_a"))
        XCTAssertEqual(fullModel.valueB, ValueWrapper(value: "something_b"))
        XCTAssertEqual(fullModel.valueC, ValueWrapper(value: "something_c"))
        XCTAssertEqual(fullModel.valueD, ValueWrapper(value: "something_d"))

        XCTAssertEqual(emptyModel.valueA, ValueWrapper(value: nil))
        XCTAssertEqual(emptyModel.valueB, ValueWrapper(value: nil))
        XCTAssertEqual(emptyModel.valueC, ValueWrapper(value: "C"))
        XCTAssertEqual(emptyModel.valueD, nil)
    }

    func testCustomUnOptionalTransform() throws {
        let json = "{}"
        let model = try JSONDecoder().decode(CustomUnOptional.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.one, .zero)
        XCTAssertEqual(model.two, .zero)
    }

    func testCustomOptionalTransform() throws {
        let json = "{}"
        let model = try JSONDecoder().decode(CustomOptional.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.one, EnumInt.three)
        XCTAssertEqual(model.two, nil)
    }

    func testCustomTransformCodec() throws {
        let json = """
        {"id": 1, "tp": "left|right"}
        """
        let model = try JSONDecoder().decode(CustomTransformCodec.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.tuple?.0, "left")
        XCTAssertEqual(model.tuple?.1, "right")
        XCTAssertEqual(model.tupleOptional?.0, nil)

        let jsonData = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        XCTAssertEqual(jsonObject["id"] as? Int, 1)
        XCTAssertEqual(jsonObject["tuple"] as? String, "left|right")
        //        XCTAssertEqual(String(data: jsonData, encoding: .utf8), "{\"id\":1,\"tuple\":\"left|right\"}")
    }

//    func testDateTransfrom() throws {
//        struct TransformExampleModel: Codable {
//            @CodingTransformer(SecondDateTransform())
//            var sencondsDate: Date?
//
//            @CodingTransformer(MillisecondDateTransform())
//            var millSecondsDate: Date?
//        }
//
//        let date = Date()
//        let json = """
//        {"sencondsDate": \(date.timeIntervalSince1970), "millSecondsDate": \(date.timeIntervalSince1970 * 1000)}
//        """
//
//        let model = try JSONDecoder().decode(TransformExampleModel.self, from: json.data(using: .utf8)!)
//        XCTAssertEqual(model.sencondsDate?.timeIntervalSince1970, date.timeIntervalSince1970)
//        XCTAssertEqual(model.millSecondsDate?.timeIntervalSince1970, date.timeIntervalSince1970)
//    }
}
