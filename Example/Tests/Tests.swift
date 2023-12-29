import XCTest
import SmartCodable
import HandyJSON
import ObjectMapper
import HandyJSON
import CleanJSON


let count = 10000 // or 1, 10, 100, 1000, 10000
let data = airportsJSON(count: count)

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testObjectMapper() {
        measure {
            let json = String(data: data, encoding: .utf8)!
            do {
                let objects = try Mapper<ObjectMapperModel>().mapArray(JSONString: json)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
    
    func testHandyJSON() {
        measure {
            let json = String(data: data, encoding: .utf8)
            let objects = JSONDeserializer<Handy>.deserializeModelArrayFrom(json: json)
            XCTAssertEqual(objects?.count, count)
        }
    }
    
    func testCodable() {
        measure {
            do {
                let decoder = JSONDecoder()
                let objects = try decoder.decode([Airport].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
    
    
    func testSmart() {
        measure {
            let json = String(data: data, encoding: .utf8)
            guard let objects = [Smart].deserialize(json: json) as? [Smart] else {
                return
            }
            XCTAssertEqual(objects.count, count)
        }
    }
    
    
    func testCleanJSON() {
        measure {
            let decoder = CleanJSONDecoder()
            do {
                let objects = try decoder.decode([Airport].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
}



func airportsJSON(count: Int) -> Data {
    let resource = "airports\(count)"
    let url = Bundle.main.url(forResource: resource, withExtension: "json")
    guard let url = url,
        let data = try? Data(contentsOf: url) else {
            fatalError()
    }
    return data
}



// ObjectMapper
struct ObjectMapperModel: ImmutableMappable {
    
    var name: String
    var iata: String
    var icao: String
    var coordinates: [Double]
    var runways: [Runway]
    
    init(map: Map) throws {
        name = try map.value("name")
        iata = try map.value("iata")
        icao = try map.value("icao")
        coordinates = try map.value("coordinates")
        runways = try map.value("runways")
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        iata <- map["iata"]
        icao <- map["icao"]
        coordinates <- map["coordinates"]
        runways <- map["runways"]
    }
    
    struct Runway: ImmutableMappable {
        enum Surface: String {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        var direction: String
        var distance: Int
        var surface: Surface
        
        init(map: Map) throws {
            direction = try map.value("direction")
            distance = try map.value("distance")
            surface = try map.value("surface")
        }
        
        mutating func mapping(map: Map) {
            direction <- map["direction"]
            distance <- map["distance"]
            surface <- map["surface"]
        }
    }
}


// HandyJSON
struct Handy: HandyJSON {
    
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    var runways: [Runway]?
    
    struct Runway: HandyJSON {
        enum Surface: String, HandyJSONEnum {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        var direction: String?
        var distance: Int?
        var surface: Surface?
    }
}




// Codable & CleanJSON
struct Airport: Codable {
    let name: String
    let iata: String
    let icao: String
    let coordinates: [Double]
    let runways: [Runway]

    struct Runway: Codable {
        enum Surface: String, Codable {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        let direction: String
        let distance: Int
        let surface: Surface
    }
}




// SmartCodable
struct Smart: SmartCodable {
    
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    var runways: [Runway]?
    
    struct Runway: SmartCodable {
        enum Surface: String, SmartCaseDefaultable {
            static var defaultCase: Smart.Runway.Surface = .other
            
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        var direction: String?
        var distance: Int?
        var surface: Surface?
    }
}



