import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "nickName": "String",
        ]
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)

        let tranformer1 = model.toDictionary()
        print(tranformer1 as Any)
    }
    
    struct Model: SmartCodable {
        var name: String = ""
        var nickName: String = ""
        var bigName: String = ""
        
        enum CodingKeys: CodingKey {
            case name
            case nickName
            case bigName
        }

        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.name <--- ["nickName"],
                CodingKeys.bigName <--- ["nickName"],
            ]
        }
        
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(nickName, forKey: CodingKeys.nickName)
            try container.encode(name, forKey: CodingKeys.name)
            try container.encode(bigName, forKey: CodingKeys.bigName)

        }
    }
}

