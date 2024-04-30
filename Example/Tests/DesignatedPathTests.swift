//
//  DesignatedPathTests.swift
//  SmartCodable_Tests
//
//  Created by Charles on 2024/4/27.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
import SmartCodable

class DesignatedPathTests: XCTestCase {
    func testDeserializeArrayPath() {
        let jsonString = """
        {
            "people": [
                {
                    "name": "John Doe",
                    "age": 30
                },
                {
                    "name": "Jane Smith",
                    "age": 25
                }
            ]
        }
        """

        if let models = [PathModel].deserialize(from: jsonString, designatedPath: "people") {
            XCTAssertEqual(models.count, 2)
            XCTAssertEqual(models[0].name, "John Doe")
            XCTAssertEqual(models[0].age, 30)
            XCTAssertEqual(models[1].name, "Jane Smith")
            XCTAssertEqual(models[1].age, 25)
        } else {
            XCTFail("Failed to deserialize models from array path")
        }
    }

    func testDeserializeNestedArrayPath() {
        let jsonString = """
        {
            "person": {
                "name": "John Doe",
                "friends": [
                    {
                        "name": "Alice",
                        "age": 25
                    },
                    {
                        "name": "Bob",
                        "age": 28
                    }
                ]
            }
        }
        """

        if let model = NestedArrayModel.deserialize(from: jsonString, designatedPath: "person") {
            XCTAssertEqual(model.name, "John Doe")
            XCTAssertEqual(model.friends?.count, 2)
            XCTAssertEqual(model.friends?[0].name, "Alice")
            XCTAssertEqual(model.friends?[0].age, 25)
            XCTAssertEqual(model.friends?[1].name, "Bob")
            XCTAssertEqual(model.friends?[1].age, 28)
        } else {
            XCTFail("Failed to deserialize nested array model")
        }
    }

    func testDeserializeInvalidPath() {
        let jsonString = """
        {
            "person": {
                "name": "John Doe",
                "age": 30
            }
        }
        """

        if let model = PathModel.deserialize(from: jsonString, designatedPath: "invalid.path") {
            XCTAssertEqual(model.name, nil)
            XCTAssertEqual(model.age, nil)
        } else {
            XCTFail("Deserialization should fail for invalid path")
        }
    }

    func testDeserializeEmptyPath() {
        let jsonString = """
        {
            "name": "John Doe",
            "age": 30
        }
        """

        if let model = PathModel.deserialize(from: jsonString, designatedPath: "") {
            XCTAssertEqual(model.name, "John Doe")
            XCTAssertEqual(model.age, 30)
        } else {
            XCTFail("Failed to deserialize model with empty path")
        }
    }

    func testDeserializeArrayWithPath() {
        let jsonString = """
        {
            "data": {
                "names": ["Alice", "Bob", "Charlie"]
            }
        }
        """

        if let models = [PathArrayModel].deserialize(from: jsonString, designatedPath: "data.names") {
            XCTAssertEqual(models.count, 3)
        } else {
            XCTFail("Failed to deserialize array with designated path")
        }
    }

    func testDeserializeNestedStructure() {
        let jsonString = """
        {
          "code": 200,
          "message": "Success",
          "data": {
            "school": {
              "name": "ABC University",
              "departments": [
                {
                  "name": "Computer Science",
                  "courses": [
                    {
                      "code": "CS101",
                      "title": "Introduction to Computer Science"
                    },
                    {
                      "code": "CS201",
                      "title": "Data Structures and Algorithms"
                    }
                  ]
                },
                {
                  "name": "Mathematics",
                  "courses": [
                    {
                      "code": "MATH101",
                      "title": "Calculus I"
                    },
                    {
                      "code": "MATH201",
                      "title": "Linear Algebra"
                    }
                  ]
                }
              ]
            }
          }
        }
        """

        if let school = School.deserialize(from: jsonString, designatedPath: "data.school") {
            XCTAssertEqual(school.name, "ABC University")
            XCTAssertEqual(school.departments?.count, 2)

            XCTAssertEqual(school.departments?[0].name, "Computer Science")
            XCTAssertEqual(school.departments?[0].courses?.count, 2)
            XCTAssertEqual(school.departments?[0].courses?[0].code, "CS101")
            XCTAssertEqual(school.departments?[0].courses?[0].title, "Introduction to Computer Science")
            XCTAssertEqual(school.departments?[0].courses?[1].code, "CS201")
            XCTAssertEqual(school.departments?[0].courses?[1].title, "Data Structures and Algorithms")

            XCTAssertEqual(school.departments?[1].name, "Mathematics")
            XCTAssertEqual(school.departments?[1].courses?.count, 2)
            XCTAssertEqual(school.departments?[1].courses?[0].code, "MATH101")
            XCTAssertEqual(school.departments?[1].courses?[0].title, "Calculus I")
            XCTAssertEqual(school.departments?[1].courses?[1].code, "MATH201")
            XCTAssertEqual(school.departments?[1].courses?[1].title, "Linear Algebra")
        } else {
            XCTFail("Failed to deserialize nested structure")
        }

        guard let departments = [Department].deserialize(from: jsonString, designatedPath: "data.school.departments") else {
            XCTFail("Failed to deserialize departments")
            return
        }

        XCTAssertEqual(departments.count, 2)
    }
}

extension DesignatedPathTests {
    struct PathModel: SmartCodable {
        var name: String?
        var age: Int?
    }

    struct NestedArrayModel: SmartCodable {
        var name: String?
        var friends: [Friend]?

        struct Friend: SmartCodable {
            var name: String = ""
            var age: Int = 0
        }
    }

    struct PathArrayModel: SmartCodable {
        var name: [String]?
    }

    struct Course: SmartCodable {
        var code: String?
        var title: String?
    }

    struct Department: SmartCodable {
        var name: String?
        var courses: [Course]?
    }

    struct School: SmartCodable {
        var name: String?
        var departments: [Department]?
    }
}
