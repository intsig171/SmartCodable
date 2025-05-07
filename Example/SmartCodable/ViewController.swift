import UIKit
import SmartCodable

struct Country: SmartCodable {
    
    var name: String?
    var channels: [Channel]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case channels
    }
}

struct Channel: SmartCodable {
    
    var name: String?
    var type: ChannelType = .unknown
    
    enum CodingKeys: String, CodingKey {
        case name
        case type = "ddType"
    }
}

enum ChannelType: Int, SmartCaseDefaultable {
    case unknown = -1
    case a = 1
    case b = 2
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsons: [[String: Any]] = [
            [
                "channels":[
                    [
                        "name":"a",
                        "ddType":0
                    ],
                    [
                        "name":"b",
                        "ddType":2
                    ]
                ],
                "name":"China"
            ]
        ]
        let countrys = jsons.compactMap { Country.deserialize(from: $0) }
        print(countrys)
    }
}

