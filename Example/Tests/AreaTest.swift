//
//  AreaTest.swift
//  SmartCodable_Tests
//
//  Created by qixin on 2024/1/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
import SmartCodable
import HandyJSON
import ObjectMapper
import HandyJSON


let areaCount = 31


class AreaTest: XCTestCase {
    
    var areaData: Data = Data()
    override func setUp() {
        super.setUp()
        areaData = areaJSON()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testAreaHandyJSON() {
        measure {
            let json = String(data: areaData, encoding: .utf8)
            let objects = JSONDeserializer<AreaHandy>.deserializeModelArrayFrom(json: json)
            XCTAssertEqual(objects?.count, areaCount)
        }
    }
    
    func testAreaCodable() {
        measure {
            do {
                let decoder = JSONDecoder()
                let objects = try decoder.decode([AreaCodable].self, from: areaData)
                XCTAssertEqual(objects.count, areaCount)
            } catch {
                XCTAssertNil(error)
            }
        }
    }


    func testAreaSmart() {
        measure {
            guard let objects = [AreaSmart].deserialize(data: areaData) as? [AreaSmart] else {
                return
            }
            
            XCTAssertEqual(objects.count, areaCount)
        }
    }
}


func areaJSON() -> Data {
    let resource = "area"
    let url = Bundle.main.url(forResource: resource, withExtension: "json")
    guard let url = url,
        let data = try? Data(contentsOf: url) else {
            fatalError()
    }
    return data
}


// HandyJSON
struct AreaHandy: HandyJSON {
    
    var areaCode: String = ""
    var name: String = ""
    var city: [City] = []
    
    struct City: HandyJSON {
        var name: String = ""
        var areaCode: String = ""
        var district: [District] = []
        
        struct District: HandyJSON {
            var name: String = ""
            var areaCode: String = ""
        }
    }
}




// Codable & CleanJSON
struct AreaCodable: Codable {
    
    var areaCode: String = ""
    var name: String = ""
    var city: [City] = []
    
    struct City: Codable {
        var name: String = ""
        var areaCode: String = ""
        var district: [District] = []
        
        struct District: Codable {
            var name: String = ""
            var areaCode: String = ""
        }
    }
}




// SmartCodable
struct AreaSmart: SmartCodable {
    
    
    var areaCode: String = ""
    var name: String = ""
    var city: [City] = []
    
    struct City: SmartCodable {
        var name: String = ""
        var areaCode: String = ""
        var district: [District] = []
        
        struct District: SmartCodable {
            var name: String = ""
            var areaCode: String = ""
        }
    }
}



