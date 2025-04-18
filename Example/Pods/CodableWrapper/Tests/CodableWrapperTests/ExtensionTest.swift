//
//  ExtensionTest.swift
//
//
//  Created by winddpan on 2023/1/5.
//

import CodableWrapper
import XCTest

@Codable
struct HashableModel: Hashable {
    var value1: String?
}

struct NavtiveHashableModel: Hashable, Codable {
    var value1: String?
}

struct NavtiveHashableModel2: Hashable, Codable {
    var value1: String?
}

final class ExtensionTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHashable() throws {
        let a = HashableModel(value1: "abc")
        let b = HashableModel(value1: "abc")

        let c = NavtiveHashableModel(value1: "abc")
        let d = NavtiveHashableModel2(value1: "abc")

        XCTAssertEqual(a.hashValue, b.hashValue)
        XCTAssertEqual(a.hashValue, c.hashValue)
        XCTAssertEqual(c.hashValue, d.hashValue)
    }
}
